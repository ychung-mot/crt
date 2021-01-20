using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.District
{
    public class DistrictDto
    {
        [JsonPropertyName("id")] 
        public decimal DistrictId { get; set; }
        public decimal DistrictNumber { get; set; }
        public string DistrictName { get; set; }
        public DateTime? EndDate { get; set; }
        [JsonPropertyName("name")]
        public string Description { get => $"{DistrictNumber}-{DistrictName}"; }
    }
}