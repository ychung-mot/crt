using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.ServiceArea
{
    public class ServiceAreaDto
    {
        [JsonPropertyName("id")]
        public decimal ServiceAreaId { get; set; }
        public decimal ServiceAreaNumber { get; set; }
        public string ServiceAreaName { get; set; }
        public decimal DistrictId { get; set; }
        public DateTime? EndDate { get; set; }
        [JsonPropertyName("name")]
        public string Description { get => $"{ServiceAreaNumber}-{ServiceAreaName}"; }

    }
}