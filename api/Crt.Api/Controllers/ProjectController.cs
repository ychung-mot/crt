using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Project;
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
            [FromQuery] string? regions,
            [FromQuery] string searchText, [FromQuery] bool? isInProgress, [FromQuery] string projectManagerIds,
            [FromQuery] int pageSize, [FromQuery] int pageNumber, [FromQuery] string orderBy = "ProjectNumber", [FromQuery] string direction = "")
        {
            return await _projectService.GetProjectsAsync(regions, searchText, isInProgress, projectManagerIds, pageSize, pageNumber, orderBy, direction);
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
    }
}
