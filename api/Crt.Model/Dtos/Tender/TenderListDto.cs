using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Tender
{
    public class TenderListDto
    {
        [JsonPropertyName("id")]
        public decimal TenderId { get; set; }
        public decimal ProjectId { get; set; }
        public string TenderNumber { get; set; }
        public DateTime? PlannedDate { get; set; }
        public DateTime? ActualDate { get; set; }
        public decimal TenderValue { get; set; }
        public decimal BidValue { get; set; }
        public string Comment { get; set; }
        public DateTime? EndDate { get; set; }
        public bool CanDelete { get => true; }

        [JsonIgnore]
        public virtual CodeLookupDto WinningCntrctrLkup { get; set; }

        public string WinningCntrctr { get => WinningCntrctrLkup.Description; }
    }
}
