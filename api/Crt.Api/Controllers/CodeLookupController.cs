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
           return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.CapIndx).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet ("rcnumbers")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetRcNumbers()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Rc).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("nearesttowns")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetNearestTowns()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.NearstTwn).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("phases")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetPhases()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Phase).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("fiscalyears")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetFiscalYears()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.FiscalYear).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("quantities")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetQuantity()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Quantity).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("accomplishments")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetAccomplishments()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Accomplishment).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("contractors")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetContractors()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Contractor).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("fundingtypes")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetFundingTypes()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.FundingType).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("ratiorecordtypes")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetRatioRecordTypes()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.RatioRecordType).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("electoraldistricts")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetElectoralDistricts()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.ElectoralDistrict).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("highways")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetHighways()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Highway).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("economicregions")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetEconomicRegions()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.EconomicRegion).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("codesets")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetCodeSetLookups()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.CodeSetLookup).OrderBy(x => x.DisplayOrder));
        }

        [HttpGet("managers")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetProjectManagers()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.ProjectManager));
        }

        [HttpGet("programs")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetProjectPrograms()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.Program));
        }

        [HttpGet("programcategories")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetProjectProgramCategories()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.ProgramCategory));
        }

        [HttpGet("servicelines")]
        public ActionResult<IEnumerable<CodeLookupDto>> GetServiceLines()
        {
            return Ok(_validator.CodeLookup.Where(x => x.CodeSet == CodeSet.ServiceLine));
        }
    }
}