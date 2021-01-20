using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Project
{
    public class ProjectCreateDto
    {
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public decimal CapIndxLkupId { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal RegionId { get; set; }
        public decimal RcLkupId { get; set; }
        public decimal ProjectMgrId { get; set; }
        public decimal NearstTwnLkupId { get; set; }
    }
}
