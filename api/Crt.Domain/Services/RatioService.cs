using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.HttpClients;
using Crt.HttpClients.Models;
using Crt.Model;
using Crt.Model.Dtos.Ratio;
using Crt.Model.Dtos.Segments;
using Crt.Model.Utils;
using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{

    public interface IRatioService
    {
        Task<RatioDto> GetRatioByIdAsync(decimal ratioId);
        Task<IEnumerable<RatioDto>> GetRatiosByRatioTypeAsync(decimal ratioTypeId);
        Task<(decimal ratioId, Dictionary<string, List<string>> errors)> CreateRatioAsync(RatioCreateDto ratio);
        Task<(bool NotFound, Dictionary<string, List<string>> errors)> UpdateRatioAsync(RatioUpdateDto ratio);
        Task<(bool NotFound, Dictionary<string, List<string>> errors)> DeleteRatioAsync(decimal projectId, decimal ratioId);
        Task<(bool NotFound, Dictionary<string, List<string>> errors)> CalculateProjectRatios(decimal projectId);
    }

    public class RatioService : CrtServiceBase, IRatioService
    {
        private IRatioRepository _ratioRepo;
        private IUserRepository _userRepo;
        private ISegmentRepository _segmentRepo;
        private IGeoServerApi _geoServerApi;
        private IDataBCApi _dataBCApi;
        private IServiceAreaRepository _serviceAreaRepo;
        private IDistrictRepository _districtRepo;

        public RatioService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork,
                IRatioRepository ratioRepo, ISegmentRepository segmentRepo, IUserRepository userRepo, IGeoServerApi geoServerApi, 
                IDataBCApi dataBCApi, IServiceAreaRepository serviceAreaRepo, IDistrictRepository districtRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _ratioRepo = ratioRepo;
            _userRepo = userRepo;
            _segmentRepo = segmentRepo;
            _geoServerApi = geoServerApi;
            _dataBCApi = dataBCApi;
            _serviceAreaRepo = serviceAreaRepo;
            _districtRepo = districtRepo;
        }

        public async Task<(decimal ratioId, Dictionary<string, List<string>> errors)> CreateRatioAsync(RatioCreateDto ratio)
        {
            var errors = new Dictionary<string, List<string>>();
            errors = _validator.Validate(Entities.Ratio, ratio, errors);

            await ValidateRatio(ratio, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtRatio = await _ratioRepo.CreateRatioAsync(ratio);

            _unitOfWork.Commit();

            return (crtRatio.RatioId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> errors)> DeleteRatioAsync(decimal projectId, decimal ratioId)
        {
            var ratio = await _ratioRepo.GetRatioByIdAsync(ratioId);

            if (ratio == null || ratio.ProjectId != projectId)
            {
                return (true, null);
            }

            //errors is returned but is always empty?
            var errors = new Dictionary<string, List<string>>();

            await _ratioRepo.DeleteRatioAsync(ratioId);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<RatioDto> GetRatioByIdAsync(decimal ratioId)
        {
            return await _ratioRepo.GetRatioByIdAsync(ratioId);
        }

        public async Task<IEnumerable<RatioDto>> GetRatiosByRatioTypeAsync(decimal ratioTypeId)
        {
            return await _ratioRepo.GetRatiosByRatioTypeAsync(ratioTypeId);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> errors)> UpdateRatioAsync(RatioUpdateDto ratio)
        {
            var crtRatio = await _ratioRepo.GetRatioByIdAsync(ratio.RatioId);

            if (crtRatio == null || ratio.ProjectId != ratio.ProjectId)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();
            errors = _validator.Validate(Entities.Ratio, ratio, errors);

            await ValidateRatio(ratio, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _ratioRepo.UpdateRatioAsync(ratio);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> errors)> CalculateProjectRatios(decimal projectId)
        {
            var totalLengthOfSegments = 0.0;
            var errors = new Dictionary<string, List<string>>();

            //clear the current ratios
            await _ratioRepo.DeleteAllRatiosByProjectIdAsync(projectId);

            //load the project segments
            List<SegmentGeometryListDto> projectSegments = await _segmentRepo.GetSegmentGeometryListsAsync(projectId);
            
            //  determine the project extent
            var segmentBBox = await _geoServerApi.GetProjectExtent(projectId);

            //iterate thru the segments 
            foreach (var segment in projectSegments)
            {
                //get the full segment length and add to the total
                var segmentLength = 
                    await _geoServerApi.GetTotalSegmentLength(BuildGeometryStringFromCoordinates(segment.Geometry));
                totalLengthOfSegments += segmentLength;
            }

            //get polygons of interest for each Electoral District, Service Area, MoTI District & Economic Region
            var serviceAreaPolygons = await _geoServerApi.GetPolygonOfInterestForServiceArea(segmentBBox);
            var districtPolygons = await _geoServerApi.GetPolygonOfInterestForDistrict(segmentBBox);
            var electoralPolygons = await _dataBCApi.GetPolygonOfInterestForElectoralDistrict(segmentBBox);
            var economicRegionPolygons = await _dataBCApi.GetPolygonOfInterestForEconomicRegion(segmentBBox);

            //call function to create the ratios
            await CreateDeterminedRatios(serviceAreaPolygons, projectSegments, totalLengthOfSegments, projectId, RatioRecordType.ServiceArea);
            await CreateDeterminedRatios(districtPolygons, projectSegments, totalLengthOfSegments, projectId, RatioRecordType.District);
            await CreateDeterminedRatios(electoralPolygons, projectSegments, totalLengthOfSegments, projectId, RatioRecordType.ElectoralDistrict);
            await CreateDeterminedRatios(economicRegionPolygons, projectSegments, totalLengthOfSegments, projectId, RatioRecordType.EconomicRegion);

            //save the determined ratios to the database
            _unitOfWork.Commit();

            return (false, errors);
        }

        private async Task CreateDeterminedRatios(List<PolygonLayer> polygons, List<SegmentGeometryListDto> projectSegments,
            double totalLengthOfSegments, decimal projectId, string recordType)
        {
            var totalRatio = 0.0;
            //get the service area ratio record lookup id
            var ratioRecordTypeId = _validator.CodeLookup
                .Where(x => x.CodeSet == CodeSet.RatioRecordType 
                && x.CodeName == recordType).FirstOrDefault().CodeLookupId;

            //how much of this segment resides within the service area polygon
            foreach (var polygon in polygons)
            {
                //get the percentage of the segment
                var percentInPolygon = await GetLengthWithinPolygon(totalLengthOfSegments, projectSegments, polygon);

                if (percentInPolygon > 0)
                {
                    totalRatio += percentInPolygon;
                    
                    //we need to do a check on the last segment to verify 
                    // our total ratio doesn't exceed or recede 1.00
                    if (totalRatio >= 1.00)
                    {
                        //we need to adjust it down to 100
                        percentInPolygon = percentInPolygon - (totalRatio - 1.00);
                    } else
                    {
                        //we'll only adjust the ratio up if it's the last item
                        if (polygon == polygons.Last())
                            percentInPolygon = percentInPolygon + (1.00 - totalRatio);
                    }
                                        
                    //generate the new ratio
                    var newRatio = new RatioCreateDto
                    {
                        ProjectId = projectId,
                        Ratio = (decimal)percentInPolygon,
                        RatioRecordTypeLkupId = ratioRecordTypeId
                    };
                    
                    //branch code based on recordType as the linking Id is written to a different place
                    switch (recordType)
                    {
                        case RatioRecordType.ServiceArea:
                            //service Id lines up with the 
                            newRatio.ServiceAreaId = _serviceAreaRepo.GetAllServiceAreas()
                                .Where(x => x.ServiceAreaNumber == Convert.ToDecimal(polygon.Number))
                                .FirstOrDefault().ServiceAreaId;
                            break;
                        case RatioRecordType.EconomicRegion:
                            newRatio.RatioRecordLkupId = _validator.CodeLookup
                                .Where(x => x.CodeSet == CodeSet.EconomicRegion && x.CodeValueText == polygon.Number)
                                .FirstOrDefault().CodeLookupId;
                            break;
                        case RatioRecordType.ElectoralDistrict:
                            newRatio.RatioRecordLkupId = _validator.CodeLookup
                                .Where(x => x.CodeSet == CodeSet.ElectoralDistrict && x.CodeValueText == polygon.Name)
                                .FirstOrDefault().CodeLookupId;
                            break;
                        case RatioRecordType.District:
                            newRatio.DistrictId = _districtRepo.GetAllDistricts()
                                .Where(x => x.DistrictNumber == Convert.ToDecimal(polygon.Number))
                                .FirstOrDefault().DistrictId;
                            break;
                    }
                    
                    await _ratioRepo.CreateRatioAsync(newRatio);
                }
            }
        }

        private async Task<double> GetLengthWithinPolygon(double totalLengthOfSegments, List<SegmentGeometryListDto> projectSegments, PolygonLayer layerPolygon)
        {
            var serviceAreaLength = 0.0;

            foreach (var segment in projectSegments)
            {
                var result = await _geoServerApi.GetSegmentLengthWithinPolygon(BuildGeometryStringFromCoordinates(segment.Geometry)
                    , BuildGeometryStringFromCoordinates(layerPolygon.NTSGeometry));

                //get the clipped length, this is how much of this segment exists within the polygon
                serviceAreaLength += result.clippedLength;
            }

            var percentInPolygon = Math.Round((serviceAreaLength / totalLengthOfSegments), 2);
            
            return percentInPolygon;
        }

        private string BuildGeometryStringFromCoordinates(NetTopologySuite.Geometries.Geometry geometry)
        {
            string geometryString = "";

            foreach (Coordinate coordinate in geometry.Coordinates)
            {
                geometryString += coordinate.X + "\\," + coordinate.Y;
                if (coordinate != geometry.Coordinates.Last())
                {
                    geometryString += "\\,";
                }
            }

            return geometryString;
        }

        private async Task ValidateRatio(RatioSaveDto ratio, Dictionary<string, List<string>> errors)
        {
            if (ratio.DistrictId != null)
            {
                if (!await _ratioRepo.DistrictExists((decimal)ratio.DistrictId))
                {
                    errors.AddItem(Fields.DistrictId, $"District ID [{ratio.DistrictId}] does not exist");
                }
            }

            if (ratio.ServiceAreaId != null)
            {
                if (!await _ratioRepo.ServiceAreaExists((decimal)ratio.ServiceAreaId))
                {
                    errors.AddItem(Fields.ServiceAreaId, $"Service Area ID [{ratio.ServiceAreaId}] does not exist");
                }
            }
        }
    }
}
