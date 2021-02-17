using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.QtyAccmp
{
    public class QtyAccmpListDto
    {
        [JsonPropertyName("id")]
        public decimal QtyAccmpId { get; set; }
        public decimal ProjectId { get; set; }
        public decimal Forecast { get; set; }
        public decimal? Schedule7 { get; set; }
        public decimal Actual { get; set; }
        public string Comment { get; set; }
        public DateTime? EndDate { get; set; }
        public bool CanDelete { get => true; }

        [JsonIgnore]
        public CodeLookupDto FiscalYearLkup { get; set; }
        [JsonIgnore]
        public CodeLookupDto QtyAccmpLkup { get; set; }
        public string FiscalYear { get => FiscalYearLkup.Description; }
        public string QtyAccmpType { get => QtyAccmpLkup.CodeSet;  }
        public string QtyAccmpName { get => QtyAccmpLkup.CodeName;  }
    }
}
