using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Note;
using Crt.Model.Dtos.Region;
using Crt.Model.Dtos.User;
using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Project
{
    public class ProjectDto
    {
        [JsonPropertyName("id")]
        public decimal ProjectId { get; set; }
        public string ProjectNumber { get; set; }
        public string ProjectName { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public decimal RegionId { get; set; }
        public decimal? CapIndxLkupId { get; set; }
        public decimal? NearstTwnLkupId { get; set; }
        public decimal? RcLkupId { get; set; }
        public decimal? ProjectMgrLkupId { get; set; }
        public decimal? AnncmentValue { get; set; }
        public decimal? C035Value { get; set; }
        public string AnncmentComment { get; set; }
        public decimal? EstimatedValue { get; set; }
        public DateTime? EndDate { get; set; }

        public CodeLookupDto CapIndxLkup { get; set; }
        public CodeLookupDto NearstTwnLkup { get; set; }
        public CodeLookupDto ProjectMgrLkup { get; set; }
        public CodeLookupDto RcLkup { get; set; }
        public RegionDto Region { get; set; }
        public IList<NoteDto> Notes { get; set; }
    }
}
