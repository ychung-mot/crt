using Crt.Model.Dtos.Role;
using Crt.Model.Dtos.RolePermission;
using Crt.Model.Dtos.User;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.UserRole
{
    public class UserRoleDto
    {
        [JsonPropertyName("id")]
        public decimal UserRoleId { get; set; }
        public decimal RoleId { get; set; }
        public decimal SystemUserId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
