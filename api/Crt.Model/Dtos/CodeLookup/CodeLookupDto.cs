using Crt.Model.Utils;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.CodeLookup
{
    public class CodeLookupDto : CodeLookupBaseDto
    {
        [JsonPropertyName("id")]
        public decimal CodeLookupId { get; set; }
        public decimal? CodeValueNum { get; set; }
        public string CodeValueFormat { get; set; }
        [JsonPropertyName("name")]
        public string Description
        {
            get
            {
                var code = CodeValueFormat == "NUMBER" ? CodeValueNum?.ToString() : CodeValueText;
                return code.IsEmpty() || CodeSet == Crt.Model.CodeSet.CodeSetLookup ? CodeName : $"{code}-{CodeName}";
            }
        }
    }
}
