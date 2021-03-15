using Crt.Model.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.CodeLookup
{
    public class CodeLookupListDto : CodeLookupBaseDto
    {
        [JsonPropertyName("id")]
        public decimal CodeLookupId { get; set; }
        [JsonIgnore]
        public string CodeValueFormat { get; set; }
        [JsonIgnore]
        public decimal? CodeValueNum { get; set; }
        public bool IsActive => EndDate == null || EndDate > DateTime.Today;
        public bool IsReferenced { get; set; }
        public bool canDelete { get; set; }
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
