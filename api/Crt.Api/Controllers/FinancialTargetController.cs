using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Model;
using Crt.Model.Dtos.FinTarget;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/financialtargets")]
    [ApiController]
    public class FinancialTargetController : CrtControllerBase
    {
        public FinancialTargetController(CrtCurrentUser currentUser)
            : base(currentUser)
        {
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<List<FinTargetListDto>>> GetFinTargetsByFiscalYearAsync(decimal fiscalYear)
        {
            throw new NotImplementedException();
            //await Task.CompletedTask;

        }
    }
}
