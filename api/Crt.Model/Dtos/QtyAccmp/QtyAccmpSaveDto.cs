using System;

namespace Crt.Model.Dtos.QtyAccmp
{
    public class QtyAccmpSaveDto
    {
        public decimal ProjectId { get; set; }
        public decimal FiscalYearLkupId { get; set; }
        public decimal QtyAccmpLkupId { get; set; }
        public decimal Forecast { get; set; }
        public decimal? Schedule7 { get; set; }
        public decimal Actual { get; set; }
        public string Comment { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
