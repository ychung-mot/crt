using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtFinTargetHist
    {
        public decimal FinTargetHistId { get; set; }
        public decimal FinTargetId { get; set; }
        public decimal ProjectId { get; set; }
        public string Description { get; set; }
        public decimal? Amount { get; set; }
        public decimal? FiscalYearLkupId { get; set; }
        public decimal? ElementId { get; set; }
        public decimal? PhaseLkupId { get; set; }
        public decimal? ForecastTypeLkupId { get; set; }
        public DateTime EffectiveDateHist { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? EndDateHist { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string AppCreateUserid { get; set; }
        public DateTime AppCreateTimestamp { get; set; }
        public Guid AppCreateUserGuid { get; set; }
        public string AppLastUpdateUserid { get; set; }
        public DateTime AppLastUpdateTimestamp { get; set; }
        public Guid AppLastUpdateUserGuid { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }
    }
}
