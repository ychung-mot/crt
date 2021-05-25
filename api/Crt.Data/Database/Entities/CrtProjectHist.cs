using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtProjectHist
    {
        public decimal ProjectHistId { get; set; }
        public decimal ProjectId { get; set; }
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public decimal RegionId { get; set; }
        public decimal? CapIndxLkupId { get; set; }
        public string NearstTwnLkupId { get; set; }
        public decimal? RcLkupId { get; set; }
        public decimal? ProjectMgrLkupId { get; set; }
        public decimal? AnncmentValue { get; set; }
        public decimal? C035Value { get; set; }
        public decimal? EstimatedValue { get; set; }
        public string AnncmentComment { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? EndDateHist { get; set; }
        public DateTime EffectiveDateHist { get; set; }
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
    }
}
