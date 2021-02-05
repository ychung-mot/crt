using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Tender
{
    public class TenderUpdateDto : TenderSaveDto
    {
        [JsonPropertyName("id")]
        public decimal TenderId { get; set; }
    }
}
