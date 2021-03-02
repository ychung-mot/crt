using Crt.Model.Dtos.CodeLookup;
using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Ratio
{
    public class RatioSaveDto
    {
        
        public decimal ProjectId { get; set; }
        public decimal? Ratio { get; set; }
        public decimal? RatioRecordLkupId { get; set; }
        public decimal RatioRecordTypeLkupId { get; set; }
        public decimal? ServiceAreaId { get; set; }
        public decimal? DistrictId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
