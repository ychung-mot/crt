using Crt.Model.Dtos.RolePermission;
using Crt.Model.Dtos.UserRole;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Role
{
    public class RoleDto
    {
        public RoleDto()
        {
            Permissions = new List<decimal>();
        }
        [JsonPropertyName("id")]
        public decimal RoleId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsReferenced { get; set; }
        public IList<decimal> Permissions { get; set; }
    }
}
