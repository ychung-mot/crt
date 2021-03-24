using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Element;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/elements")]
    [ApiController]
    public class ElementController : CrtControllerBase
    {
        private IElementService _elementService;

        public ElementController(CrtCurrentUser currentUser, IElementService elementService)
            : base(currentUser)
        {
            _elementService = elementService;
        }

        [HttpGet(Name = "GetElements")]
        [RequiresPermission(Permissions.CodeRead)]
        public async Task<ActionResult<IEnumerable<ElementDto>>> GetElementsAsync()
        {
            return Ok(await _elementService.GetElementsAsync());
        }

        [HttpGet(Name = "SearchElements")]
        [Route("search")]
        [RequiresPermission(Permissions.CodeRead)]
        public async Task<ActionResult<PagedDto<ElementListDto>>> SearchElementAsync(
            [FromQuery] string searchText, [FromQuery] bool? isActive,
            [FromQuery] int pageSize, [FromQuery] int pageNumber, [FromQuery] string orderBy = "Code", [FromQuery] string direction = "")
        {
            return await _elementService.SearchElementsAsync(searchText, isActive, pageSize, pageNumber, orderBy, direction);
        }

        [HttpGet("{id}", Name = "GetElement")]
        [RequiresPermission(Permissions.CodeRead)]
        public async Task<ActionResult<IEnumerable<ElementDto>>> GetElementAsync(decimal id)
        {
            return Ok(await _elementService.GetElementAsync(id));
        }
    }
}
