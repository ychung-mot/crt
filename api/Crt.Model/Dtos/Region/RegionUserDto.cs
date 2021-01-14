using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Region
{
    public class RegionUserDto
    {
        public decimal RegionUserId { get; set; }
        public decimal RegionId { get; set; }
        public decimal SystemUserId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}