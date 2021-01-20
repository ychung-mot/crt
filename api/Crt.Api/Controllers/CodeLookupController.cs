using System.Collections.Generic;
using System.Linq;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Microsoft.AspNetCore.Mvc;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/codelookup")]
    [ApiController]
    public class CodeLookupController : CrtControllerBase
    {
        private IFieldValidatorService _validator;

        public CodeLookupController(IFieldValidatorService validator)
        {
            _validator = validator;
        }

        [HttpGet ("maintenancetypes")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetMaintenanceTypes()
        {
           return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.WrkRptMaintType));
        }

        [HttpGet ("unitofmeasures")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetUnitOfMeasures()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.UnitOfMeasure));
        }

        [HttpGet("featuretypes")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetFeatureTypes()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.FeatureType));
        }
    }
}