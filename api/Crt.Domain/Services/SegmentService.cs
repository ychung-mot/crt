using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.HttpClients.Models;
using Crt.Model;
using Crt.Model.Dtos.Segments;
using Crt.Model.Utils;
using NetTopologySuite;
using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface ISegmentService
    {
        Task<SegmentDto> GetSegmentByIdAsync(decimal segmentID);
        Task<(decimal segmentId, Dictionary<string, List<string>> errors)> CreateSegmentAsync(SegmentCreateDto segment);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteSegmentAsync(decimal projectId, decimal segmentId);
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

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteSegmentAsync(decimal projectId, decimal segmentId)
        {
            throw new NotImplementedException();
        }

        public async Task<SegmentDto> GetSegmentByIdAsync(decimal segmentID)
        {
            throw new NotImplementedException();
        }

    }
}
