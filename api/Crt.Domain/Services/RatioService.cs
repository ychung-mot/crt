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

        public RatioService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork,
                IRatioRepository ratioRepo, ISegmentRepository segmentRepo, IUserRepository userRepo, IGeoServerApi geoServerApi, 
                IDataBCApi dataBCApi)
            : base(currentUser, validator, unitOfWork)
        {
            _ratioRepo = ratioRepo;
            _userRepo = userRepo;
            _segmentRepo = segmentRepo;
            _geoServerApi = geoServerApi;
            _dataBCApi = dataBCApi;
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
            var errors = new Dictionary<string, List<string>>();

            return (false, errors);
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
