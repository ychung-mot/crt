using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtCodeLookup
    {
        public CrtCodeLookup()
        {
            CrtProjectCapIndxLkups = new HashSet<CrtProject>();
            CrtProjectNearstTwnLkups = new HashSet<CrtProject>();
            CrtProjectRcLkups = new HashSet<CrtProject>();
        }

        public decimal CodeLookupId { get; set; }
        public string CodeSet { get; set; }
        public string CodeName { get; set; }
        public string CodeValueText { get; set; }
        public decimal? CodeValueNum { get; set; }
        public string CodeValueFormat { get; set; }
        public decimal? DisplayOrder { get; set; }
        public DateTime? EndDate { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }

        public virtual ICollection<CrtProject> CrtProjectCapIndxLkups { get; set; }
        public virtual ICollection<CrtProject> CrtProjectNearstTwnLkups { get; set; }
        public virtual ICollection<CrtProject> CrtProjectRcLkups { get; set; }
    }
}
