using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectSearchDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        [JsonIgnore]
        public decimal RegionNumber { get; set; }
        [JsonIgnore]
        public string RegionName { get; set; }
        [JsonIgnore]
        public string ProjectNumber { get; set; }
        [JsonIgnore]
        public string ProjectName { get; set; }

        [JsonPropertyName("regionId")]
        public string regionField { get => $"{RegionNumber}-{RegionName}"; }
        [JsonPropertyName("projectNumber")]
        public string projectField { get => $"{ProjectNumber}-{ProjectName}"; }
        public DateTime? EndDate { get; set; }
        public bool IsInProgress { get => EndDate == null || DateTime.Today < EndDate; }

    }
}
