using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Model;
using Crt.Model.Dtos.Tender;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/tenders")]
    [ApiController]
    public class TenderController : CrtControllerBase
    {
        public TenderController(CrtCurrentUser currentUser)
            : base(currentUser)
        {
        }

        [HttpGet("{id}", Name = "GetTender")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<TenderDto>> GetTenderByIdAsync(decimal id)
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

            var tender = new TenderDto
            {
                TenderId = 1,
                ProjectId = 1,
                TenderNumber = "P1-0001",
                PlannedDate = new DateTime(2020, 5, 14).Date,
                ActualDate = new DateTime(2020, 5, 10).Date,
                TenderValue = 25250M,
                WinningCntrctrLkupId = 416,
                BidValue = 25000M,
                Comment = "Test Comment 1"
            };

            return Ok(tender);
            #endregion
        }
    }
}
