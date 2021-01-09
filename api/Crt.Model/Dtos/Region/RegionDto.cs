using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Region
{
    class RegionDto
    {
        [JsonPropertyName("id")] 
        public decimal RegionId { get; set; }
        public decimal RegionNumber { get; set; }
        [JsonPropertyName("name")]
        public string RegionName { get; set; }
        public decimal RegionUserId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
