using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.QtyAccmp;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.ProjectPlanning
{
    public class ProjectPlanDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        [JsonIgnore]
        public string ProjectNumber { get; set; }
        [JsonIgnore]
        public string ProjectName { get; set; }

        [JsonPropertyName("projectNumber")]
        public string Project { get => $"{ProjectNumber}-{ProjectName}"; }

        public List<FinTargetListDto> FinTargets { get; set; }
        public List<QtyAccmpListDto> QytAccmps { get; set; }

        public ProjectPlanDto()
        {
            FinTargets = new List<FinTargetListDto>();
            QytAccmps = new List<QtyAccmpListDto>();
        }
    }
}
