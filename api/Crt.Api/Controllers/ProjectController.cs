using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Note;
using Crt.Model.Dtos.Project;
using Crt.Model.Dtos.Region;
using Crt.Model.Dtos.User;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects")]
    [ApiController]
    public class ProjectController : CrtControllerBase
    {
        public ProjectController()
        {

        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<PagedDto<ProjectSearchDto>>> GetProjectsAsync(
            [FromQuery] string? regions,
            [FromQuery] string searchText, [FromQuery] bool? isInProgress, [FromQuery] string projectManagerIds,
            [FromQuery] int pageSize, [FromQuery] int pageNumber, [FromQuery] string orderBy = "username", [FromQuery] string direction = "")
        {
            //filter with search criteria
            //filter with user's region

            #region mockup
            await Task.CompletedTask;

            var project1 = new ProjectSearchDto
            {
                ProjectId = 1,
                ProjectNumber = "P1",
                ProjectName = "Test Project - Road rehabilitation 1",
                RegionNumber = 1,
                RegionName = "South Coast",
                EndDate = null
            };

            var project2 = new ProjectSearchDto
            {
                ProjectId = 2,
                ProjectNumber = "P2",
                ProjectName = "Test Project - Road rehabilitation 2",
                RegionNumber = 0,
                RegionName = "Headquarters",
                EndDate = null
            };

            var project3 = new ProjectSearchDto
            {
                ProjectId = 3,
                ProjectNumber = "P3",
                ProjectName = "Test Project - Road rehabilitation 3",
                RegionNumber = 1,
                RegionName = "South Coast",
                EndDate = null
            };

            var projects = new List<ProjectSearchDto> { project1, project2, project3 };

            var pagedDTO = new PagedDto<ProjectSearchDto>
            {
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = projects.Count,
                SourceList = projects,
                OrderBy = orderBy,
                Direction = direction
            };

            return Ok(pagedDTO);
            #endregion
        }

        [HttpGet("{id}", Name = "GetProject")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<ProjectDto>> GetProjectByIdAsync(decimal id)
        {
            #region mockup
            await Task.CompletedTask;

            var project = new ProjectDto
            {
                ProjectId = 1,
                ProjectNumber = "P1",
                ProjectName = "Test Project - Road rehabilitation 1",
                Description = "Test Project - Description",
                Scope = "Test Project - Scope",
                CapIndxLkupId = 15,
                EndDate = null,
                RegionId = 1,
                RcLkupId = null,
                ProjectMgrId = 1,
                NearstTwnLkupId = 1,
                CapIndxLkup = new CodeLookupDto
                {
                    CodeLookupId = 1,
                    CodeSet = "CAPINDX",
                    CodeName = "Capitalizable-All components>40yrs",
                    CodeValueText = "10",
                    DisplayOrder = 0,
                },
                Region = new RegionDto
                {
                    RegionId = 1,
                    RegionNumber = 1,
                    RegionName = "South Coast",
                    EndDate = null
                },
                RcLkup = null,
                ProjectMgr = new UserSearchDto
                {
                    SystemUserId = 1,
                    LastName = "Roebuck",
                    FirstName = "John",
                    Username = "RJOHN",
                },
                Notes = new List<NoteDto> {
                    new NoteDto
                    {
                        NoteId = 1,
                        NoteType = "STATUS",
                        Comment = "Status comment 1",
                        UserId = "RJOHN",
                        NoteDate = new DateTime(2020, 1, 15)
                    },
                    new NoteDto
                    {
                        NoteId = 2,
                        NoteType = "STATUS",
                        Comment = "Status comment 2",
                        UserId = "RJOHN",
                        NoteDate = new DateTime(2020, 1, 20)
                    },
                    new NoteDto
                    {
                        NoteId = 3,
                        NoteType = "EMR",
                        Comment = "EMR comment 1",
                        UserId = "RJOHN",
                        NoteDate = new DateTime(2020, 1, 19)
                    } 
                }
            };

            return Ok(project);
            #endregion
        }

        [HttpPost]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult<ProjectCreateDto>> CreateUser(ProjectCreateDto project)
        {
            throw new NotImplementedException();

            //var response = await _projectService.CreateUserAsync(project);

            //if (response.Errors.Count > 0)
            //{
            //    return ValidationUtils.GetValidationErrorResult(response.Errors, ControllerContext);
            //}

            //return CreatedAtRoute("GetProject", new { id = response.ProjectId }, await _projectService.GetProjectAsync(response.ProjectId));
        }

        [HttpPut("{id}")]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult> UpdateProject(decimal id, ProjectUpdateDto project)
        {
            throw new NotImplementedException();

            //if (id != project.ProjectId)
            //{
            //    throw new Exception($"The project ID from the query string does not match that of the body.");
            //}

            //var response = await _projectService.UpdateUserAsync(project);

            //if (response.NotFound)
            //{
            //    return NotFound();
            //}

            //if (response.Errors.Count > 0)
            //{
            //    return ValidationUtils.GetValidationErrorResult(response.Errors, ControllerContext);
            //}

            //return NoContent();
        }

        [HttpDelete("{id}")]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult> DeleteProject(decimal id, ProjectDeleteDto project)
        {
            throw new NotImplementedException();

            //if (id != project.SystemProjectId)
            //{
            //    throw new Exception($"The system project ID from the query string does not match that of the body.");
            //}

            //var response = await _projectService.DeleteProjectAsync(project);

            //if (response.NotFound)
            //{
            //    return NotFound();
            //}

            //if (response.Errors.Count > 0)
            //{
            //    return ValidationUtils.GetValidationErrorResult(response.Errors, ControllerContext);
            //}

            //return NoContent();
        }
    }
}
