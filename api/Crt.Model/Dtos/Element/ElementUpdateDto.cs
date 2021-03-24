using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Element
{
    public class ElementUpdateDto : ElementSaveDto
    {
        [JsonPropertyName("id")]
        public decimal ElementId { get; set; }
    }
}
