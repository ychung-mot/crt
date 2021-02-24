using Crt.Model.Dtos.Project;
using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentDto
    {
        [JsonPropertyName("id")]
        public decimal SegmentId { get; set; }
        public decimal ProjectId { get; set; }
        public Geometry Geometry { get; set; }
        public decimal? StartLatitude { get; set; }
        public decimal? StartLongitude { get; set; }
        public decimal? EndLatitude { get; set; }
        public decimal? EndLongitude { get; set; }
        public DateTime? EndDate { get; set; }
        public virtual ProjectDto Project { get; set; }
    }
}
