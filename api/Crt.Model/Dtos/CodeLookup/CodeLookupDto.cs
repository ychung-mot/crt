using Crt.Model.Utils;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.CodeLookup
{
    public class CodeLookupDto
    {
        [JsonPropertyName("id")]
        public decimal CodeLookupId { get; set; }
        public string CodeSet { get; set; }
        public string CodeName { get; set; }
        public string CodeValueText { get; set; }
        public decimal? CodeValueNum { get; set; }
        public string CodeValueFormat { get; set; }
        public decimal? DisplayOrder { get; set; }
        [JsonPropertyName("name")]
        public string Description
        {
            get
            {
                var code = CodeValueFormat == "NUMBER" ? CodeValueNum?.ToString() : CodeValueText;
                return code.IsEmpty() ? CodeName : $"{code}-{CodeName}";
            }
        }
    }
}
