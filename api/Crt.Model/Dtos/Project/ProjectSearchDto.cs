using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectSearchDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        public decimal RegionNumber { get; set; }
        public string RegionName { get; set; }
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsInProgress { get => EndDate == null || DateTime.Today < EndDate; }
    }
}
