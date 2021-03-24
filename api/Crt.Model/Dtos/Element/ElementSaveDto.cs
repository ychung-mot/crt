using System;

namespace Crt.Model.Dtos.Element
{
    public class ElementSaveDto
    {
        public string Code { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public decimal? ProgramLkupId { get; set; }
        public decimal? ProgramCategoryLkupId { get; set; }
        public decimal? ServiceLineLkupId { get; set; }
        public bool? IsActive { get; set; }
        public decimal? DisplayOrder { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
