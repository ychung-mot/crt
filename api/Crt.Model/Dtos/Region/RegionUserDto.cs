using System;

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