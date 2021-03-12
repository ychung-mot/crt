using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos.Segments;
using Crt.Model.Utils;
using NetTopologySuite;
using NetTopologySuite.Geometries;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface ISegmentService
    {
        Task<SegmentListDto> GetSegmentByIdAsync(decimal segmentID);
        Task<(decimal segmentId, Dictionary<string, List<string>> errors)> CreateSegmentAsync(SegmentCreateDto segment);
        Task<(bool NotFound, Dictionary<string, List<string>> errors)> DeleteSegmentAsync(decimal projectId, decimal segmentId);
        Task<List<SegmentListDto>> GetSegmentsAsync(decimal projectId);
    }

    public class SegmentService : CrtServiceBase, ISegmentService
    {
        private ISegmentRepository _segmentRepo;
        private IUserRepository _userRepo;
        protected GeometryFactory _geometryFactory;

        public SegmentService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork,
                ISegmentRepository segmentRepo, IUserRepository userRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _segmentRepo = segmentRepo;
            _userRepo = userRepo;
            _geometryFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
        }

        public async Task<(decimal segmentId, Dictionary<string, List<string>> errors)> CreateSegmentAsync(SegmentCreateDto segment)
        {
            var errors = new Dictionary<string, List<string>>();

            if (segment.Route.Length < 2 || segment.Route.Length == 0)
            {
                //we need 2 points to create a line
                errors.AddItem(Fields.SegmentRoute, "Segment Route must contain at least 2 points");
            }

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtSegment = await _segmentRepo.CreateSegmentAsync(segment);

            _unitOfWork.Commit();

            return (crtSegment.SegmentId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> errors)> DeleteSegmentAsync(decimal projectId, decimal segmentId)
        {
            var segment = await _segmentRepo.GetSegmentByIdAsync(segmentId);

            if (segment == null || segment.ProjectId != projectId)
            {
                return (true, null);
            }

            //errors is returned but is always empty?
            var errors = new Dictionary<string, List<string>>();

            await _segmentRepo.DeleteSegmentAsync(segmentId);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<SegmentListDto> GetSegmentByIdAsync(decimal segmentId)
        {
            return await _segmentRepo.GetSegmentByIdAsync(segmentId);
        }

        public async Task<List<SegmentListDto>> GetSegmentsAsync(decimal projectId)
        {
            return await _segmentRepo.GetSegmentsAsync(projectId);
        }
    }
}
