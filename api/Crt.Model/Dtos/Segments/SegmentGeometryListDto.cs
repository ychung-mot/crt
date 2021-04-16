using NetTopologySuite.Geometries;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentGeometryListDto : SegmentDto
    {
        public Geometry Geometry;
    }
}
