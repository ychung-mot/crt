using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentDto
    {
        [JsonPropertyName("id")]
        public decimal SegmentId { get; set; }
        public decimal ProjectId { get; set; }
        public string Description { get; set; }
        public decimal? StartLatitude { get; set; }
        public decimal? StartLongitude { get; set; }
        public decimal? EndLatitude { get; set; }
        public decimal? EndLongitude { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
