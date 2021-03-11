using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.CodeLookup
{
    public class CodeLookupUpdateDto : CodeLookupBaseDto
    {
        [JsonPropertyName("id")]
        public decimal CodeLookupId { get; set; }
    }
}
