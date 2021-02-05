using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Element;
using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.Project;
using Crt.Model.Dtos.QtyAccmp;
using Crt.Model.Dtos.Tender;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects")]
    [ApiController]
    public class ProjectController : CrtControllerBase
    {
        private IProjectService _projectService;

        public ProjectController(CrtCurrentUser currentUser, IProjectService projectService) 
            : base(currentUser)
        {
            _projectService = projectService;
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<PagedDto<ProjectSearchDto>>> GetProjectsAsync(
            [FromQuery] string? regionIds,
            [FromQuery] string searchText, [FromQuery] bool? isInProgress, [FromQuery] string projectManagerIds,
            [FromQuery] int pageSize, [FromQuery] int pageNumber, [FromQuery] string orderBy = "ProjectNumber", [FromQuery] string direction = "")
        {
            return await _projectService.GetProjectsAsync(regionIds, searchText, isInProgress, projectManagerIds, pageSize, pageNumber, orderBy, direction);
        }

        [HttpGet("{id}", Name = "GetProject")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<ProjectDto>> GetProjectByIdAsync(decimal id)
        {
            var project = await _projectService.GetProjectAsync(id);

            if (project == null)
            {
                return NotFound();
            }

            var problem = IsRegionIdAuthorized(project.RegionId);
            if (problem != null)
            {
                return Unauthorized(problem);
            }

            return project;
        }

        [HttpPost]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult<ProjectCreateDto>> CreateProject(ProjectCreateDto project)
        {
            var problem = IsRegionIdAuthorized(project.RegionId);
            if (problem != null)
            {
                return Unauthorized(problem);
            }

            var response = await _projectService.CreateProjectAsync(project);

            if (response.errors.Count > 0)
            {
                return ValidationUtils.GetValidationErrorResult(response.errors, ControllerContext);
            }

            return CreatedAtRoute("GetProject", new { id = response.projectId }, await _projectService.GetProjectAsync(response.projectId));
        }

        [HttpPut("{id}")]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult> UpdateProject(decimal id, ProjectUpdateDto project)
        {
            var problem = IsRegionIdAuthorized(project.RegionId);
            if (problem != null)
            {
                return Unauthorized(problem);
            }

            if (id != project.ProjectId)
            {
                throw new Exception($"The project ID from the query string does not match that of the body.");
            }

            var response = await _projectService.UpdateProjectAsync(project);

            if (response.NotFound)
            {
                return NotFound();
            }

            if (response.Errors.Count > 0)
            {
                return ValidationUtils.GetValidationErrorResult(response.Errors, ControllerContext);
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult> DeleteProject(decimal id, ProjectDeleteDto project)
        {
            if (id != project.ProjectId)
            {
                throw new Exception($"The system project ID from the query string does not match that of the body.");
            }

            var response = await _projectService.DeleteProjectAsync(project);

            if (response.NotFound)
            {
                return NotFound();
            }

            if (response.Errors.Count > 0)
            {
                return ValidationUtils.GetValidationErrorResult(response.Errors, ControllerContext);
            }

            return NoContent();
        }

        [HttpGet("{id}/projecttender")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<ProjectTenderDto>> GetProjectTenderAsync(decimal id)
        {
            var projectTender = await _projectService.GetProjectTenderAsync(id);

            if (projectTender == null)
            {
                return NotFound();
            }

            var problem = IsRegionIdAuthorized(projectTender.RegionId);
            if (problem != null)
            {
                return Unauthorized(problem);
            }

            return projectTender;
        }

        [HttpGet("{id}/projectplan")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<ProjectPlanDto>> GetProjectPlanAsync(decimal id)
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

            planning.QtyAccmps.Add(new QtyAccmpListDto
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

            planning.QtyAccmps.Add(new QtyAccmpListDto
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
