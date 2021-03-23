using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.Segments;
using Crt.Model.Utils;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite;
using NetTopologySuite.Geometries;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{

    public interface ISegmentRepository
    {
        Task<CrtSegment> CreateSegmentAsync(SegmentCreateDto segment);
        Task<CrtSegment> UpdateSegmentAsync(SegmentUpdateDto segment);
        Task DeleteSegmentAsync(decimal segmentId);
        Task<SegmentListDto> GetSegmentByIdAsync(decimal segmentId);
        Task<List<SegmentListDto>> GetSegmentsAsync(decimal projectId);
    }

    public class SegmentRepository : CrtRepositoryBase<CrtSegment>, ISegmentRepository
    {
        protected GeometryFactory _geometryFactory;

        public SegmentRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
            _geometryFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
        }

        public async Task<CrtSegment> CreateSegmentAsync(SegmentCreateDto segment)
        {
            var crtSegment = LoadCrtSegment(new CrtSegment(), segment);

            await DbSet.AddAsync(crtSegment);

            return crtSegment;
        }

        public async Task<CrtSegment> UpdateSegmentAsync(SegmentUpdateDto segment)
        {
            var crtSegment = await DbSet.FirstAsync(x => x.SegmentId == segment.SegmentId);

            LoadCrtSegment(crtSegment, segment);

            return crtSegment;
        }

        private CrtSegment LoadCrtSegment(CrtSegment crtSegment, SegmentSaveDto segment)
        {
            var isPoint = segment.Route.Length == 1 ||
                (segment.Route.Length == 2 & segment.Route[0][0] == segment.Route[1][0] && segment.Route[0][1] == segment.Route[1][1]);

            Geometry geometry = isPoint ?
                _geometryFactory.CreatePoint(segment.Route.ToTopologyCoordinates()[0])
                : _geometryFactory.CreateLineString(segment.Route.ToTopologyCoordinates());

            var entity = Mapper.Map(segment, crtSegment);
            entity.Geometry = geometry;

            if (!isPoint)
            {
                var lineString = (LineString)geometry;

                entity.StartLongitude = (decimal)lineString.StartPoint.X;
                entity.StartLatitude = (decimal)lineString.StartPoint.Y;
                entity.EndLongitude = (decimal)lineString.EndPoint.X;
                entity.EndLatitude = (decimal)lineString.EndPoint.Y;
            }
            else
            {
                entity.StartLongitude = segment.Route[0][0];
                entity.StartLatitude = segment.Route[0][1];
                entity.EndLongitude = null;
                entity.EndLatitude = null;
            }

            return crtSegment;
        }

        public async Task DeleteSegmentAsync(decimal segmentId)
        {
            var segment = await DbSet.FirstAsync(x => x.SegmentId == segmentId);

            DbSet.Remove(segment);
        }

        public async Task<SegmentListDto> GetSegmentByIdAsync(decimal segmentId)
        {
            var segment = await DbSet.AsNoTracking()
                .Include(x => x.Project)
                .FirstOrDefaultAsync(x => x.SegmentId == segmentId);

            return Mapper.Map<SegmentListDto>(segment);
        }

        public async Task<List<SegmentListDto>> GetSegmentsAsync(decimal projectId)
        {
            var segments = await DbSet.AsNoTracking()
                .Where(x => x.ProjectId == projectId)
                .ToListAsync();

            return Mapper.Map<List<SegmentListDto>>(segments);
        }
    }
}