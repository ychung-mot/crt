using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Element
{
    public class ElementListDto
    {
        [JsonPropertyName("id")]
        public decimal ElementId { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public string Program { get => ProgramLkup?.CodeValueText; }
        public string ProgramName { get => ProgramLkup?.CodeName; }
        public string ProgramCategory { get => ProgramCategoryLkup?.CodeValueText; }
        public string ProgramCategoryName { get => ProgramCategoryLkup?.CodeName; }
        public string ServiceLine { get => ServiceLineLkup?.CodeValueText; }
        public string ServiceLineName { get => ServiceLineLkup?.CodeName; }
        public bool? IsActive { get; set; }
        public decimal? DisplayOrder { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsReferenced { get; set; }
        public bool canDelete { get; set; }

        [JsonIgnore]
        public virtual CodeLookupDto ProgramCategoryLkup { get; set; }
        [JsonIgnore]
        public virtual CodeLookupDto ProgramLkup { get; set; }
        [JsonIgnore]
        public virtual CodeLookupDto ServiceLineLkup { get; set; }
    }
}
