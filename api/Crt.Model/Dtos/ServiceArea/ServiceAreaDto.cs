using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.ServiceArea
{
    class ServiceAreaDto
    {
        [JsonPropertyName("id")]
        public decimal ServiceAreaId { get; set; }
        public decimal ServiceAreaNumber { get; set; }
        [JsonPropertyName("name")]
        public string ServiceAreaName { get; set; }
        public decimal DistrictNumber { get; set; }
        public decimal ServiceAreaUserId { get; set; }
        public decimal RegionUserId { get; set; }
        public decimal RegionNumber { get; set; }

    }
}
