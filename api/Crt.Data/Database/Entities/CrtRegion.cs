using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtRegion
    {
        public CrtRegion()
        {
            CrtDistricts = new HashSet<CrtDistrict>();
            CrtRegionUsers = new HashSet<CrtRegionUser>();
        }

        public decimal RegionId { get; set; }
        public decimal RegionNumber { get; set; }
        public string RegionName { get; set; }
        public DateTime? EndDate { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }

        public virtual ICollection<CrtDistrict> CrtDistricts { get; set; }
        public virtual ICollection<CrtRegionUser> CrtRegionUsers { get; set; }
    }
}
