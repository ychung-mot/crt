namespace Crt.Model.Dtos.Segments
{
    public class SegmentListDto : SegmentSaveDto
    {
        public bool CanDelete { get => true; }
        public string StartCoordinates { get => $"{StartLatitude},{StartLongitude}"; }
        public string EndCoordinates { get => $"{EndLatitude},{EndLongitude}"; }
    }
}
