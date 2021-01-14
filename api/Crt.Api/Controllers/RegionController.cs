using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model.Dtos.Region;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/regions")]
    [ApiController]
    public class RegionController : CrtControllerBase
    {
        private IRegionService _regionService;

       public RegionController(IRegionService regionService)
        {
            _regionService = regionService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<RegionDto>>> GetAllRegionsAsync()
        {
            return Ok(await _regionService.GetAllRegionsAsync());
        }

        [HttpGet("{number}", Name = "GetRegion")]
        public async Task<ActionResult<RegionDto>> GetRegionByNumberAsync(decimal number)
        {
            return Ok(await _regionService.GetRegionByRegionNumber(number));
        }
    }
}
