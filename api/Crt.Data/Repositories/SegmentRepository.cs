using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
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

namespace Crt.Data.Repositories
{
    
    public interface ISegmentRepository
    {
        Task<CrtSegment> CreateSegmentAsync(SegmentCreateDto segment);
        Task DeleteSegmentAsync(decimal segmentId);
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

        public Task DeleteSegmentAsync(decimal segmentId)
        {
            throw new NotImplementedException();
        }

    }
    
}
