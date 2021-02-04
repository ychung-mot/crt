using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Element;
using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.ProjectPlanning;
using Crt.Model.Dtos.QtyAccmp;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/projectplan")]
    [ApiController]
    public class ProjectPlanController : CrtControllerBase
    {
        private IProjectService _projectService;

        public ProjectPlanController(CrtCurrentUser currentUser, IProjectService projectService)
            : base(currentUser)
        {
            _projectService = projectService;
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<ProjectPlanDto>> GetFinancialPlanAsync(decimal projectId)
        {
            //var project = await _projectService.GetProjectAsync(projectId);

            //if (project == null)
            //{
            //    return NotFound();
            //}

            //var problem = IsRegionIdAuthorized(project.RegionId);
            //if (problem != null)
            //{
            //    return Unauthorized(problem);
            //}

            #region Mockup
            await Task.CompletedTask;

            var planning = new ProjectPlanDto();

            planning.ProjectId = 1;
            planning.ProjectName = "Mockup Project 1";
            planning.ProjectNumber = "P001";

            planning.FinTargets.Add(new FinTargetListDto
            {
                FinTargetId = 1,
                ProjectId = 1,
                Description = "Test financial target comment",
                Amount = 25000M,
               
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

                Element = new ElementDto
                {
                    Code = "Bm"
                }
            });

            planning.FinTargets.Add(new FinTargetListDto
            {
                FinTargetId = 2,
                ProjectId = 1,
                Description = "Test financial target comment",
                Amount = 5000M,

                FiscalYearLkup = new CodeLookupDto
                {
                    CodeLookupId = 361,
                    CodeSet = CodeSet.FiscalYear,
                    CodeName = "2019/2020",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 10
                },

                PhaseLkup = new CodeLookupDto
                {
                    CodeLookupId = 346,
                    CodeSet = CodeSet.Phase,
                    CodeName = "Engineer",
                    CodeValueText = "E",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 1
                },

                ForecastTypeLkup = new CodeLookupDto
                {
                    CodeLookupId = 510,
                    CodeSet = CodeSet.ForecastType,
                    CodeName = "Priority",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 2
                },

                Element = new ElementDto
                {
                    Code = "Tc"
                }
            });

            planning.QytAccmps.Add(new QtyAccmpListDto
            {
                QtyAccmpId = 1,
                ProjectId = 1,
                Forecast = 90,
                Schedule7 = 98,
                Actual = 100,
                Comment = "Test quantity target comment",

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

                QtyAccmpLkup = new CodeLookupDto
                {
                    CodeLookupId = 370,
                    CodeSet = CodeSet.Quantity,
                    CodeName = "Asphalt Mix  (tonnes)",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 1
                },
            });

            planning.QytAccmps.Add(new QtyAccmpListDto
            {
                QtyAccmpId = 2,
                ProjectId = 1,
                Forecast = 30,
                Schedule7 = 0,
                Actual = 25,
                Comment = "Test accomplishment target comment",

                FiscalYearLkup = new CodeLookupDto
                {
                    CodeLookupId = 361,
                    CodeSet = CodeSet.FiscalYear,
                    CodeName = "2019/2020",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 10
                },

                QtyAccmpLkup = new CodeLookupDto
                {
                    CodeLookupId = 374,
                    CodeSet = CodeSet.Accomplishment,
                    CodeName = "Active Transportation Project",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 1
                },
            });

            return Ok(planning);
            #endregion
        }
    }
}
