using Crt.Model.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.CodeLookup
{
    public class CodeLookupBaseDto
    {
        public string CodeSet { get; set; }
        public string CodeName { get; set; }
        public string CodeValueText { get; set; }
        public decimal? DisplayOrder { get; set; }
        public DateTime? EndDate { get; set; }
    }
}