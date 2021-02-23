using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentUpdateDto : SegmentSaveDto
    {
        [JsonPropertyName("id")]
        public decimal SegmentId { get; set; }
    }
}
