using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.Permission;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/permissions")]
    [ApiController]
    public class PermissionsController : CrtControllerBase
    {
        private IPermissionService _permissionService;

        public PermissionsController(IPermissionService permissionService)
        {
            _permissionService = permissionService;
        }

        [HttpGet]
        [RequiresPermission(Permissions.RoleRead)]
        public async Task<ActionResult<IEnumerable<PermissionDto>>> GetActivePermissionsAsync()
        {
            return Ok(await _permissionService.GetActivePermissionsAsync());
        }

    }
}
