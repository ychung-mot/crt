using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.HttpClients.Models;
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
            var crtSegment = new CrtSegment();

            var routeLine = new Line(segment.Route);
            var lineString = _geometryFactory.CreateLineString(routeLine.ToTopologyCoordinates());

            var entity = Mapper.Map(segment, crtSegment);
            entity.Geometry = lineString;

            entity.StartLongitude = (decimal)lineString.StartPoint.X;
            entity.StartLatitude = (decimal)lineString.StartPoint.Y;
            entity.EndLongitude = (decimal)lineString.EndPoint.X;
            entity.EndLatitude = (decimal)lineString.EndPoint.Y;

            await DbSet.AddAsync(entity);

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