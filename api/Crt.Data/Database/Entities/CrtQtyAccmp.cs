using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtQtyAccmp
    {
        public decimal QtyAccmpId { get; set; }
        public decimal ProjectId { get; set; }
        public decimal FiscalYearLkupId { get; set; }
        public decimal QtyAccmpLkupId { get; set; }
        public decimal Forecast { get; set; }
        public decimal? Schedule7 { get; set; }
        public decimal Actual { get; set; }
        public string Comment { get; set; }
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

        public virtual CrtCodeLookup FiscalYearLkup { get; set; }
        public virtual CrtProject Project { get; set; }
        public virtual CrtCodeLookup QtyAccmpLkup { get; set; }
    }
}
