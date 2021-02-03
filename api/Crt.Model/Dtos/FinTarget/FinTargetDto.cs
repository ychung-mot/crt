using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.FinTarget
{
    public class FinTargetDto
    {
        [JsonPropertyName("id")]
        public decimal FinTargetId { get; set; }
        public decimal ProjectId { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public decimal FiscalYearLkupId { get; set; }
        public decimal ElementId { get; set; }
        public decimal PhaseLkupId { get; set; }
        public decimal ForecastTypeLkupId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
