using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentSaveDto
    {
        public decimal ProjectId { get; set; }
        public Geometry Geometry { get; set; }
        public decimal? StartLatitude { get; set; }
        public decimal? StartLongitude { get; set; }
        public decimal? EndLatitude { get; set; }
        public decimal? EndLongitude { get; set; }
    }
}
