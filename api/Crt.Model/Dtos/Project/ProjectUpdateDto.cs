using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectUpdateDto : ProjectSaveDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
    }
}
