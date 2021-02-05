using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.QtyAccmp
{
    public class QtyAccmpDeleteDto
    {
        [JsonPropertyName("id")]
        public decimal QtyAccmpId { get; set; }
        public decimal ProjectId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
