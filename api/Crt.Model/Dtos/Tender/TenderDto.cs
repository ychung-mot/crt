using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Tender
{
    public class TenderDto
    {
        [JsonPropertyName("id")]
        public decimal TenderId { get; set; }
        public decimal ProjectId { get; set; }
        public decimal TenderNumber { get; set; }
        public DateTime? PlannedDate { get; set; }
        public DateTime? ActualDate { get; set; }
        public decimal TenderValue { get; set; }
        public decimal WinningCntrctrLkupId { get; set; }
        public string Comment { get; set; }
        public DateTime EndDate { get; set; }
    }
}
