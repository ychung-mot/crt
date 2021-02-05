using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.QtyAccmp
{
    public class QtyAccmpUpdateDto : QtyAccmpSaveDto
    {
        [JsonPropertyName("id")]
        public decimal QtyAccmpId { get; set; }
    }
}