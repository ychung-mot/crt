using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.FinTarget
{
    public class FinTargetDeleteDto
    {
        [JsonPropertyName("id")]
        public decimal FinTargetId { get; set; }
        public decimal ProjectId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
