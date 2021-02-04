using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.ProjectTender;
using Crt.Model.Dtos.Tender;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/projecttender")]
    [ApiController]
    public class ProjectTenderController : CrtControllerBase
    {
        public ProjectTenderController(CrtCurrentUser currentUser)
            : base(currentUser)
        {
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<ProjectTenderDto>> GetProjectTenderAsync(decimal projectId)
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

            var projectTender = new ProjectTenderDto();

            projectTender.ProjectId = 1;
            projectTender.ProjectName = "Mockup Project 1";
            projectTender.ProjectNumber = "P001";

            projectTender.Tenders.Add(new TenderListDto
            {
                TenderId = 1,
                ProjectId = 1,
                TenderNumber = "P1-0001",
                PlannedDate = new DateTime(2020, 5, 14).Date,
                ActualDate = new DateTime(2020, 5, 10).Date,
                TenderValue = 25250M,
                BidValue = 25000M,
                WinningCntrctrLkup = new CodeLookupDto
                {
                    CodeLookupId = 416,
                    CodeSet = CodeSet.Contractor,
                    CodeName = "Axis Mountain Technical Inc.",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 9
                },
                Comment = "Test Comment 1"
            });

            projectTender.Tenders.Add(new TenderListDto
            {
                TenderId = 2,
                ProjectId = 1,
                TenderNumber = "P1-0002",
                PlannedDate = new DateTime(2021, 5, 25).Date,
                ActualDate = new DateTime(2021, 5, 24).Date,
                TenderValue = 500000M,
                BidValue = 495965M,
                WinningCntrctrLkup = new CodeLookupDto
                {
                    CodeLookupId = 423,
                    CodeSet = CodeSet.Contractor,
                    CodeName = "Borrow Ent.",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 16
                },
            });


            return Ok(projectTender);
            #endregion
        }
    }
}
