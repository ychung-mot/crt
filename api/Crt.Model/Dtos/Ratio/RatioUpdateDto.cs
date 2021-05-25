using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Ratio
{
    public class RatioUpdateDto : RatioSaveDto
    {
        [JsonPropertyName("id")]
        public decimal RatioId { get; set; }
    }
}