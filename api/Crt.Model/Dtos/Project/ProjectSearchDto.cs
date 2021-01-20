using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Project
{
    public class ProjectSearchDto
    {
        public decimal ProjectId { get; set; }
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsInProgress { get => EndDate == null || DateTime.Today < EndDate; }
    }
}
