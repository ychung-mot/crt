using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Region
{
    public class RegionDistrictDto
    {
        public decimal RegionDistrictId { get; set; }
        public decimal RegionId { get; set; }
        public decimal DistrictId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
