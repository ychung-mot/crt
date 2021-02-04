using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtProject
    {
        public CrtProject()
        {
            CrtFinTargets = new HashSet<CrtFinTarget>();
            CrtNotes = new HashSet<CrtNote>();
            CrtQtyAccmps = new HashSet<CrtQtyAccmp>();
            CrtTenders = new HashSet<CrtTender>();
        }

        public decimal ProjectId { get; set; }
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public decimal RegionId { get; set; }
        public decimal? CapIndxLkupId { get; set; }
        public decimal? NearstTwnLkupId { get; set; }
        public decimal? RcLkupId { get; set; }
        public decimal? ProjectMgrId { get; set; }
        public decimal? AnncmentValue { get; set; }
        public decimal? C035Value { get; set; }
        public string AnncmentComment { get; set; }
        public DateTime? EndDate { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string AppCreateUserid { get; set; }
        public DateTime AppCreateTimestamp { get; set; }
        public Guid AppCreateUserGuid { get; set; }
        public string AppLastUpdateUserid { get; set; }
        public DateTime AppLastUpdateTimestamp { get; set; }
        public Guid AppLastUpdateUserGuid { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }

        public virtual CrtCodeLookup CapIndxLkup { get; set; }
        public virtual CrtCodeLookup NearstTwnLkup { get; set; }
        public virtual CrtSystemUser ProjectMgr { get; set; }
        public virtual CrtCodeLookup RcLkup { get; set; }
        public virtual CrtRegion Region { get; set; }
        public virtual ICollection<CrtFinTarget> CrtFinTargets { get; set; }
        public virtual ICollection<CrtNote> CrtNotes { get; set; }
        public virtual ICollection<CrtQtyAccmp> CrtQtyAccmps { get; set; }
        public virtual ICollection<CrtTender> CrtTenders { get; set; }
    }
}
