using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentUpdateDto : SegmentSaveDto
    {
        [JsonPropertyName("id")]
        public decimal SegmentId { get; set; }
    }
}
