using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Ratio
{
    public class RatioDto
    {
        [JsonPropertyName("id")]
        public decimal RatioId { get; set; }
        public decimal ProjectId { get; set; }
        public decimal? Ratio { get; set; }
        public decimal? RatioObjectLkupId { get; set; }
        public decimal RatioObjectTypeLkupId { get; set; }
        public decimal? ServiceAreaId { get; set; }
        public decimal? DistrictId { get; set; }
        public DateTime? EndDate { get; set; }
        
        public virtual CodeLookupDto RatioObjectLkup { get; set; }
        public virtual CodeLookupDto RatioObjectTypeLkup { get; set; }
    }
}
