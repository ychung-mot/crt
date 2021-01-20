using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Note;
using Crt.Model.Dtos.Region;
using Crt.Model.Dtos.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Project
{
    public class ProjectDto
    {
        public decimal ProjectId { get; set; }
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public decimal CapIndxLkupId { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal RegionId { get; set; }
        public decimal? RcLkupId { get; set; }
        public decimal? ProjectMgrId { get; set; }
        public decimal? NearstTwnLkupId { get; set; }

        public CodeLookupDto CapIndx { get; set; }
        public RegionDto Region { get; set; }
        public CodeLookupDto Rcl { get; set; }
        public  UserSearchDto ProjectMgr { get; set; }
        public CodeLookupDto NearstTwn { get; set; }
        public IList<NoteDto> Notes { get; set; }

    }
}
