using Crt.Model.Dtos.QtyAccmp;
using Crt.Model.Dtos.Tender;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectTenderDto
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
        
        public List<TenderListDto> Tenders { get; set; }
        public List<QtyAccmpListDto> QtyAccmps { get; set; }

        public ProjectTenderDto()
        {
            Tenders = new List<TenderListDto>();
            QtyAccmps = new List<QtyAccmpListDto>();
        }
    }
}
