using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.Ratio;
using Crt.Model.Dtos.Segments;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/ratio")]
    [ApiController]
    public class RatioController : CrtControllerBase
    {
        private IProjectService _projectService;
        private IRatioService _ratioService;

        public RatioController(CrtCurrentUser currentUser, IProjectService projectService, IRatioService ratioService)
            : base(currentUser)
        {
            _projectService = projectService;
            _ratioService = ratioService;
        }

        [HttpPost]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult<RatioDto>> CreateRatio(decimal projectId, RatioCreateDto ratio)
        {
            var result = await IsProjectAuthorized(projectId);
            if (result != null) return result;

            ratio.ProjectId = projectId;

            var response = await _ratioService.CreateRatioAsync(ratio);
            if (response.errors.Count > 0)
            {
                return ValidationUtils.GetValidationErrorResult(response.errors, ControllerContext);
            }

            return CreatedAtRoute("GetRatio", new { projectId = projectId, id = response.ratioId }, await _ratioService.GetRatioByIdAsync(response.ratioId));
        }

        [HttpGet("{id}", Name = "GetRatio")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<RatioDto>> GetRatioByIdAsync(decimal projectId, decimal id)
        {
            var result = await IsProjectAuthorized(projectId);
            if (result != null) return result;

            var ratio = await _ratioService.GetRatioByIdAsync(id);
            if (ratio == null)
            {
                return NotFound();
            }

            return Ok(ratio);
        }

        [HttpDelete("{id}")]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult> DeleteRatio(decimal projectId, decimal id)
        {
            var result = await IsProjectAuthorized(projectId);
            if (result != null) return result;

            var response = await _ratioService.DeleteRatioAsync(projectId, id);

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

        private async Task<ActionResult> IsProjectAuthorized(decimal projectId)
        {
            var project = await _projectService.GetProjectAsync(projectId);

            if (project == null)
            {
                return NotFound();
            }

            var problem = IsRegionIdAuthorized(project.RegionId);
            if (problem != null)
            {
                return Unauthorized(problem);
            }

            return null;
        }
    }
}

