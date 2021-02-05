using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.FinTarget
{
    public class FinTargetUpdateDto : FinTargetSaveDto
    {
        [JsonPropertyName("id")]
        public decimal FinTargetId { get; set; }
    }
}
