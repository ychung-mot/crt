using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtRegionDistrictHist
    {
        public decimal RegionDistrictHistId { get; set; }
        public decimal RegionDistrictId { get; set; }
        public decimal RegionId { get; set; }
        public decimal DistrictId { get; set; }
        public DateTime EffectiveDateHist { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? EndDateHist { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }
    }
}
