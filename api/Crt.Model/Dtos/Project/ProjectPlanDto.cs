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

        public List<FinTargetListDto> FinTargets { get; set; }
        public List<QtyAccmpListDto> QtyAccmps { get; set; }

        public ProjectPlanDto()
        {
            FinTargets = new List<FinTargetListDto>();
            QtyAccmps = new List<QtyAccmpListDto>();
        }
    }
}
