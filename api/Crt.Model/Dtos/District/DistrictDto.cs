using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.District
{
    class DistrictDto
    {
        [JsonPropertyName("id")]
        public decimal DistrictId { get; set; }
        public decimal DistrictNumber { get; set; }
        [JsonPropertyName("name")]
        public string DistrictName { get; set; }
        public decimal RegionNumber { get; set; }
        public decimal RegionUserId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
