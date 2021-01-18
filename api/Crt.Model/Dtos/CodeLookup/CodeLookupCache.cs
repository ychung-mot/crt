using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.CodeLookup
{
    public class CodeLookupCache
    {
        public string CodeSet { get; set; }
        [JsonPropertyName("id")]
        public decimal CodeLookupId { get; set; }
        [JsonPropertyName("name")]
        public string CodeName { get; set; }
    }
}
