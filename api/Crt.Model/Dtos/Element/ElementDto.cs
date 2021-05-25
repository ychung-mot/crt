using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Element
{
    public class ElementDto
    {
        [JsonPropertyName("id")]
        public decimal ElementId { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public decimal? ProgramLkupId { get; set; }
        public decimal? ProgramCategoryLkupId { get; set; }
        public decimal? ServiceLineLkupId { get; set; }
        public bool? IsActive { get; set; }
        public decimal? DisplayOrder { get; set; }
        public DateTime? EndDate { get; set; }

        public virtual CodeLookupDto ProgramCategoryLkup { get; set; }
        public virtual CodeLookupDto ProgramLkup { get; set; }
        public virtual CodeLookupDto ServiceLineLkup { get; set; }

        [JsonPropertyName("name")]
        public string Name
        {
            get
            {
                return $"{Code} - {Description}";
            }
        }
    }
}
