using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Tendor
{
    public class TendorDto
    {
        [JsonPropertyName("id")]
        public decimal TendorId { get; set; }
        public decimal ProjectId { get; set; }
        public string  TendorNumber { get; set; }
        public DateTime? PlannedDate { get; set; }
        public DateTime? ActualDate { get; set; }
        public decimal Value { get; set; }
        public decimal WinningContractorLkupId { get; set; }
        public decimal BidValue { get; set; }
    }
}
