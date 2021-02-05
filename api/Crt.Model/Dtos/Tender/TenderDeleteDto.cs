using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Tender
{
    public class TenderDeleteDto
    {
        [JsonPropertyName("id")]
        public decimal TenderId { get; set; }
        public decimal ProjectId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
