using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Crt.Model.Dtos.Role
{
    public class RoleCreateDto : IRoleSaveDto
    {
        public RoleCreateDto()
        {
            Permissions = new List<decimal>();
        }
        [StringLength(30)]
        public string Name { get; set; }
        [StringLength(150)]
        public string Description { get; set; }
        public DateTime? EndDate { get; set; }

        public IList<decimal> Permissions { get; set; }
    }
}
