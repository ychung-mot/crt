using Crt.Model.Dtos.Tender;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.ProjectTender
{
    public class ProjectTenderDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        [JsonIgnore]
        public string ProjectNumber { get; set; }
        [JsonIgnore]
        public string ProjectName { get; set; }

        [JsonPropertyName("projectNumber")]
        public string Project { get => $"{ProjectNumber}-{ProjectName}"; }

        public List<TenderListDto> Tenders { get; set; }

        public ProjectTenderDto()
        {
            Tenders = new List<TenderListDto>();
        }
    }
}
