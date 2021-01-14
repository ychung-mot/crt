using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtDistrict
    {
        public CrtDistrict()
        {
            CrtRegionDistricts = new HashSet<CrtRegionDistrict>();
            CrtServiceAreas = new HashSet<CrtServiceArea>();
        }

        public decimal DistrictId { get; set; }
        public decimal DistrictNumber { get; set; }
        public string DistrictName { get; set; }
        public DateTime? EndDate { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }

        public virtual ICollection<CrtRegionDistrict> CrtRegionDistricts { get; set; }
        public virtual ICollection<CrtServiceArea> CrtServiceAreas { get; set; }
    }
}
