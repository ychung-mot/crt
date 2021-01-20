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
            #region mockup
            await Task.CompletedTask;

            var project1 = new ProjectSearchDto
            {
                ProjectId = 1,
                ProjectNumber = "P1",
                ProjectName = "Test Project - Road rehabilitation 1",
                EndDate = null
            };

            var project2 = new ProjectSearchDto
            {
                ProjectId = 2,
                ProjectNumber = "P2",
                ProjectName = "Test Project - Road rehabilitation 2",
                EndDate = null
            };

            var project3 = new ProjectSearchDto
            {
                ProjectId = 3,
                ProjectNumber = "P3",
                ProjectName = "Test Project - Road rehabilitation 3",
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
                NearstTwnLkupId = null,
                CapIndx = new CodeLookupDto
                {
                    CodeLookupId = 15,
                    CodeSet = "CAPINDX",
                    CodeName = "Expense- Materiality clause not met",
                    CodeValueNum = 0,
                    DisplayOrder = 0
                },
                Region = new RegionDto
                {
                    RegionId = 1,
                    RegionNumber = 1,
                    RegionName = "South Coast",
                    EndDate = null
                },
                Rcl = null,
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

    }
}
