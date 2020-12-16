using Crt.Model.Dtos.Permission;
using Crt.Model.Dtos.Role;
using System;
using System.Collections.Generic;
using System.Text;

namespace Crt.Model.Dtos.RolePermission
{
    public class RolePermissionDto
    {
        public decimal RolePermissionId { get; set; }
        public decimal RoleId { get; set; }
        public decimal PermissionId { get; set; }
        public DateTime? EndDate { get; set; }
    }
}
