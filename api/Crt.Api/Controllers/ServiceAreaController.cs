using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.ServiceArea;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/serviceareas")]
    [ApiController]
    public class ServiceAreaController : CrtControllerBase
    {
        private IServiceAreaService _serviceAreaService;

        public ServiceAreaController(CrtCurrentUser currentUser, IServiceAreaService serviceAreaService)
            : base(currentUser)
        {
            _serviceAreaService = serviceAreaService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ServiceAreaDto>>> GetAllServiceAreasAsync()
        {
            return Ok(await _serviceAreaService.GetAllServiceAreasAsync());
        }

        [HttpGet("{id}", Name = "GetServiceArea")]
        public async Task<ActionResult<ServiceAreaDto>> GetServiceAreaByIdAsync(decimal id)
        {
            var result = await _serviceAreaService.GetServiceAreaById(id);

            if (result == null)
                return NotFound();

            return Ok(result);
        }
    }
}
