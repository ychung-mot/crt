using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Ratio
{
    public class RatioCreateDto
    {
        public decimal ProjectId { get; set; }
        public decimal? Ratio { get; set; }
        public decimal? RatioObjectLkupId { get; set; }
        public decimal RatioObjectTypeLkupId { get; set; }
        public decimal? ServiceAreaId { get; set; }
        public decimal? DistrictId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
