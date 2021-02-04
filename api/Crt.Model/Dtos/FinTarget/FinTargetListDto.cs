using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Element;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.FinTarget
{
    public class FinTargetListDto
    {
        [JsonPropertyName("id")]
        public decimal FinTargetId { get; set; }
        public decimal ProjectId { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }

        [JsonIgnore]
        public CodeLookupDto FiscalYearLkup { get; set; }
        [JsonIgnore] 
        public CodeLookupDto PhaseLkup { get; set; }
        [JsonIgnore] 
        public CodeLookupDto ForecastTypeLkup { get; set; }
        [JsonIgnore]
        public ElementDto Element { get; set; }

        public string FiscalYear { get => FiscalYearLkup.Description; }
        public string ProjectPhase { get => PhaseLkup.Description; }
        [JsonPropertyName("element")]
        public string ElementCode { get => Element.Code; }
        public string ForecastType { get => ForecastTypeLkup.Description; }
    }
}
