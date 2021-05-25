namespace Crt.Model.Dtos.Segments
{
    public class SegmentSaveDto
    {
        public decimal ProjectId { get; set; }
        public decimal[][] Route { get; set; }
        public string Description { get; set; }
    }
}
