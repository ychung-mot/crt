using Crt.Model.Dtos.Ratio;
using Crt.Model.Dtos.Segments;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Project
{
    public class ProjectLocationDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        [JsonIgnore]
        public string ProjectNumber { get; set; }
        [JsonIgnore]
        public string ProjectName { get; set; }
        [JsonIgnore]
        public decimal RegionId { get; set; }
        [JsonPropertyName("projectNumber")]
        public string Project { get => $"{ProjectNumber}-{ProjectName}"; }

        public List<RatioListDto> Ratios { get; set; }
        public List<SegmentListDto> Segments { get; set; }

        public ProjectLocationDto()
        {
            Ratios = new List<RatioListDto>();
            Segments = new List<SegmentListDto>();
        }
    }
}
