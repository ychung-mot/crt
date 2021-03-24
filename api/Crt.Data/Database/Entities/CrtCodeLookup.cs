using System;
using System.Collections.Generic;

#nullable disable

namespace Crt.Data.Database.Entities
{
    public partial class CrtCodeLookup
    {
        public CrtCodeLookup()
        {
            CrtElementProgramCategoryLkups = new HashSet<CrtElement>();
            CrtElementProgramLkups = new HashSet<CrtElement>();
            CrtElementServiceLineLkups = new HashSet<CrtElement>();
            CrtFinTargetFiscalYearLkups = new HashSet<CrtFinTarget>();
            CrtFinTargetFundingTypeLkups = new HashSet<CrtFinTarget>();
            CrtFinTargetPhaseLkups = new HashSet<CrtFinTarget>();
            CrtProjectCapIndxLkups = new HashSet<CrtProject>();
            CrtProjectNearstTwnLkups = new HashSet<CrtProject>();
            CrtProjectProjectMgrLkups = new HashSet<CrtProject>();
            CrtProjectRcLkups = new HashSet<CrtProject>();
            CrtQtyAccmpFiscalYearLkups = new HashSet<CrtQtyAccmp>();
            CrtQtyAccmpQtyAccmpLkups = new HashSet<CrtQtyAccmp>();
            CrtRatioRatioRecordLkups = new HashSet<CrtRatio>();
            CrtRatioRatioRecordTypeLkups = new HashSet<CrtRatio>();
            CrtTenders = new HashSet<CrtTender>();
        }

        public decimal CodeLookupId { get; set; }
        public string CodeSet { get; set; }
        public string CodeName { get; set; }
        public string CodeValueText { get; set; }
        public decimal? CodeValueNum { get; set; }
        public string CodeValueFormat { get; set; }
        public decimal? DisplayOrder { get; set; }
        public DateTime? EndDate { get; set; }
        public long ConcurrencyControlNumber { get; set; }
        public string DbAuditCreateUserid { get; set; }
        public DateTime DbAuditCreateTimestamp { get; set; }
        public string DbAuditLastUpdateUserid { get; set; }
        public DateTime DbAuditLastUpdateTimestamp { get; set; }

        public virtual ICollection<CrtElement> CrtElementProgramCategoryLkups { get; set; }
        public virtual ICollection<CrtElement> CrtElementProgramLkups { get; set; }
        public virtual ICollection<CrtElement> CrtElementServiceLineLkups { get; set; }
        public virtual ICollection<CrtFinTarget> CrtFinTargetFiscalYearLkups { get; set; }
        public virtual ICollection<CrtFinTarget> CrtFinTargetFundingTypeLkups { get; set; }
        public virtual ICollection<CrtFinTarget> CrtFinTargetPhaseLkups { get; set; }
        public virtual ICollection<CrtProject> CrtProjectCapIndxLkups { get; set; }
        public virtual ICollection<CrtProject> CrtProjectNearstTwnLkups { get; set; }
        public virtual ICollection<CrtProject> CrtProjectProjectMgrLkups { get; set; }
        public virtual ICollection<CrtProject> CrtProjectRcLkups { get; set; }
        public virtual ICollection<CrtQtyAccmp> CrtQtyAccmpFiscalYearLkups { get; set; }
        public virtual ICollection<CrtQtyAccmp> CrtQtyAccmpQtyAccmpLkups { get; set; }
        public virtual ICollection<CrtRatio> CrtRatioRatioRecordLkups { get; set; }
        public virtual ICollection<CrtRatio> CrtRatioRatioRecordTypeLkups { get; set; }
        public virtual ICollection<CrtTender> CrtTenders { get; set; }
    }
}
