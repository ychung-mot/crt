using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Ratio
{
    public class RatioDto : RatioSaveDto
    {
        [JsonPropertyName("id")]
        public decimal RatioId { get; set; }
        public virtual CodeLookupDto RatioRecordLkup { get; set; }
        public virtual CodeLookupDto RatioRecordTypeLkup { get; set; }
    }
}
