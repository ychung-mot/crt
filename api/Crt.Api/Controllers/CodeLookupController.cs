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

        public CodeLookupController(CrtCurrentUser currentUser, IFieldValidatorService validator)
            : base(currentUser)
        {
            _validator = validator;
        }

        [HttpGet ("capitalindexes")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetCapitalIndexes()
        {
           return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.CapIndx));
        }

        [HttpGet ("rcnumbers")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetRcNumbers()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Rc));
        }

        [HttpGet("nearesttowns")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetNearestTowns()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.NearstTwn));
        }

        [HttpGet("phases")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetPhases()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Phase));
        }

        [HttpGet("fiscalyears")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetFiscalYears()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.FiscalYear));
        }

        [HttpGet("quantities")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetQuantity()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Quantity));
        }

        [HttpGet("accomplishments")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetAccomplishments()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Accomplishment));
        }

        [HttpGet("contractors")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetContractors()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Contractor));
        }

        [HttpGet("fundingtypes")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetFundingTypes()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.FundingType));
        }
    }
}