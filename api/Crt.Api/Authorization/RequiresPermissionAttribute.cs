using Microsoft.AspNetCore.Mvc;

namespace Crt.Api.Authorization
{
    public class RequiresPermissionAttribute : TypeFilterAttribute
    {
        public RequiresPermissionAttribute(params string[] permissions) : base(typeof(RequiresPermissionFilter))
        {
            Arguments = new object[] { new PermissionRequirement(permissions) };
        }
    }
}
