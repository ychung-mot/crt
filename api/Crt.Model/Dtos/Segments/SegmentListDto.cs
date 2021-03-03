using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentListDto : SegmentSaveDto
    {
        [JsonPropertyName("id")]
        public decimal SegmentId { get; set; }
        public bool CanDelete { get => true; }
        public string StartCoordinates { get => $"{StartLatitude},{StartLongitude}"; }
        public string EndCoordinates { get => $"{EndLatitude},{EndLongitude}"; }
    }
}
