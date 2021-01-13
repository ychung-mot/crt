using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtDistrict
    {
        public CrtDistrict()
        {
            CrtServiceAreas = new HashSet<CrtServiceArea>();
        }

        public decimal DistrictId { get; set; }
        public decimal DistrictNumber { get; set; }
        public string DistrictName { get; set; }
        public decimal RegionNumber { get; set; }
        public DateTime? EndDate { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }

        public virtual CrtRegion RegionNumberNavigation { get; set; }
        public virtual ICollection<CrtServiceArea> CrtServiceAreas { get; set; }
    }
}
