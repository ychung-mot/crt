using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Element
{
    public class ElementDto
    {
        [JsonPropertyName("id")]
        public decimal ElementId { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
