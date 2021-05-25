using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Region
{
    public class RegionDto
    {
        [JsonPropertyName("id")] 
        public decimal RegionId { get; set; }
        public decimal RegionNumber { get; set; }
        public string RegionName { get; set; }
        public DateTime? EndDate { get; set; }
        [JsonPropertyName("name")]
        public string Description { get => $"{RegionNumber}-{RegionName}"; }
        public virtual ICollection<RegionDistrictDto> CrtRegionDistricts { get; set; }
    }
}