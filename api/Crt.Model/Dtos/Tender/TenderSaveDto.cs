using System;

namespace Crt.Model.Dtos.Tender
{
    public class TenderSaveDto
    {
        public decimal ProjectId { get; set; }
        public string TenderNumber { get; set; }
        public DateTime? PlannedDate { get; set; }
        public DateTime? ActualDate { get; set; }
        public decimal? TenderValue { get; set; }
        public decimal? BidValue { get; set; }
        public decimal? WinningCntrctrLkupId { get; set; }
        public string Comment { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
