using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.QtyAccmp
{
    public class QtyAccmpDto
    {
        [JsonPropertyName("id")]
        public decimal QtyAccmpId { get; set; }
        public decimal ProjectId { get; set; }
        public decimal QtyAccmpCatLkupId { get; set; }
        public decimal QtyAccmpDescLkupId { get; set; }
        public decimal Forecast { get; set; }
        public decimal Schedule7 { get; set; }
        public decimal Actual { get; set; }
        public string Comment { get; set; }
    }
}
