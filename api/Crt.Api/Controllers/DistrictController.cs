using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model.Dtos.District;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/districts")]
    [ApiController]
    public class DistrictController : CrtControllerBase
    {
        private IDistrictService _districtService;

        public DistrictController(IDistrictService districtService)
        {
            _districtService = districtService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<DistrictDto>>> GetAllRegionsAsync()
        {
            return Ok(await _districtService.GetAllDistrictsAsync());
        }

        [HttpGet("{id}", Name = "GetDistrict")]
        public async Task<ActionResult<DistrictDto>> GetDistrictByIdAsync(decimal id)
        {
            return Ok(await _districtService.GetDistrictByDistrictId(id));
        }
    }
}
