using System.Collections.Generic;

namespace Crt.Model.Dtos.Role
{
    public interface IRoleSaveDto
    {
        IList<decimal> Permissions { get; set; }
    }
}
