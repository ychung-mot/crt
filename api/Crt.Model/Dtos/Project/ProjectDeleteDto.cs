using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectDeleteDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
