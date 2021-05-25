using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.User
{
    public class UserDeleteDto
    {
        [JsonPropertyName("id")]
        public decimal SystemUserId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
