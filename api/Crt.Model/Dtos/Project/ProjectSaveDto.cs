using System;

namespace Crt.Model.Dtos.Project
{
    public class ProjectSaveDto
    {
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public decimal RegionId { get; set; }
        public decimal? CapIndxLkupId { get; set; }
        public decimal? NearstTwnLkupId { get; set; }
        public decimal? RcLkupId { get; set; }
        public decimal? ProjectMgrId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
