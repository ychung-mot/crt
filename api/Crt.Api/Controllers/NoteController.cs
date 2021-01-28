using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Model;
using Crt.Model.Dtos.Note;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/notes")]
    [ApiController]
    public class NoteController : CrtControllerBase
    {
        public NoteController(CrtCurrentUser currentUser)
             : base(currentUser)
        {

        }

        [HttpPost]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult<NoteDto>> CreateNote(NoteDto note)
        {
            throw new NotImplementedException();

            //var response = await _noteService.CreateUserAsync(note);

            //if (response.Errors.Count > 0)
            //{
            //    return ValidationUtils.GetValidationErrorResult(response.Errors, ControllerContext);
            //}

            //return CreatedAtRoute("GetProject", new { id = response.ProjectId }, await _projectService.GetProjectAsync(response.ProjectId));
        }
    }
}
