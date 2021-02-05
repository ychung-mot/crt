using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.FinTarget;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/targets")]
    [ApiController]
    public class FinTargetsController : CrtControllerBase
    {
        private IFinTargetService _finTargetService;

        public FinTargetsController(CrtCurrentUser currentUser, IFinTargetService finTargetService)
            : base(currentUser)
        {
            _finTargetService = finTargetService;
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<FinTargetDto>> GetTargetByIdAsync(decimal finTargetId)
        {
            //var finTarget = await _projectService.GetFinTargetAsync(finTargetId);

            //if (finTarget == null)
            //{
            //    return NotFound();
            //}

            //var problem = IsRegionIdAuthorized(regionId);
            //if (problem != null)
            //{
            //    return Unauthorized(problem);
            //}

            #region Mockup
            await Task.CompletedTask;

            var finTarget = new FinTargetDto {
                FinTargetId = 1,
                ProjectId = 1,
                Description = "Test financial target",
                Amount = 500000M,

                FiscalYearLkup = new CodeLookupDto
                {
                    CodeLookupId = 362,
                    CodeSet = CodeSet.FiscalYear,
                    CodeName = "2020/2021",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 11
                },

                PhaseLkup = new CodeLookupDto
                {
                    CodeLookupId = 345,
                    CodeSet = CodeSet.Phase,
                    CodeName = "Plan",
                    CodeValueText = "C",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 1
                },

                ForecastTypeLkup = new CodeLookupDto
                {
                    CodeLookupId = 509,
                    CodeSet = CodeSet.ForecastType,
                    CodeName = "Allocation",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 1
                },

                ElementId = 1
            };

            return Ok(finTarget);
            #endregion
        }
    }
}
