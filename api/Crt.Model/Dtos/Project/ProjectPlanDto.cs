using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.QtyAccmp;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectPlanDto
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
        public decimal? AnncmentValue { get; set; }
        public decimal? C035Value { get; set; }
        public string AnncmentComment { get; set; }
        public decimal? EstimatedValue { get; set; }

        public List<FinTargetListDto> FinTargets { get; set; }

        public ProjectPlanDto()
        {
            FinTargets = new List<FinTargetListDto>();
        }
    }
}
