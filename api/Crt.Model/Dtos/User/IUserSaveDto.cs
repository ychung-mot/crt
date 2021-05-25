using System;
using System.Collections.Generic;
using System.Text;

namespace Crt.Model.Dtos.User
{
    public interface IUserSaveDto
    {
        IList<decimal> UserRoleIds { get; set; }
        IList<decimal> UserRegionIds { get; set; }

    }
}
