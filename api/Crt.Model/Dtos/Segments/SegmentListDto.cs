using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentListDto : SegmentDto
    {
        public bool CanDelete { get => true; }
        public string StartCoordinates { get => $"{string.Format("{0:N6}", StartLatitude)},{string.Format("{0:N6}", StartLongitude)}"; }
        public string EndCoordinates { get => $"{string.Format("{0:N6}", EndLatitude)},{string.Format("{0:N6}", EndLongitude)}"; }
    }
}
