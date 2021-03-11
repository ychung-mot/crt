﻿using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/codetable")]
    [ApiController]
    public class CodeTableController : CrtControllerBase
    {
        private IFieldValidatorService _validator;
        private ICodeTableService _codeTableService;

        public CodeTableController(CrtCurrentUser currentUser, IFieldValidatorService validator, 
            ICodeTableService codeTableService) : base(currentUser)
        {
            _validator = validator;
            _codeTableService = codeTableService;
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<PagedDto<CodeLookupListDto>>> GetCodeLookupsAsync(
            [FromQuery] string codeSet,
            [FromQuery] string searchText, [FromQuery] bool? isActive, 
            [FromQuery] int pageSize, [FromQuery] int pageNumber, [FromQuery] string orderBy = "DisplayOrder", [FromQuery] string direction = "")
        {
            return await _codeTableService.GetCodeTablesAsync(codeSet, searchText, isActive, pageSize, pageNumber, orderBy, direction);
        }

        [HttpPost]
        [RequiresPermission(Permissions.ProjectWrite)]
        public async Task<ActionResult<CodeLookupCreateDto>> CreateCodeLookup(decimal projectId, CodeLookupCreateDto codeLookup)
        {
            // need to validate that the Code Name doesn't already exist
            //var result = await IsProjectAuthorized(projectId);
            //if (result != null) return result;

            var response = await _codeTableService.CreateCodeLookupAsync(codeLookup);
            if (response.errors.Count > 0)
            {
                return ValidationUtils.GetValidationErrorResult(response.errors, ControllerContext);
            }

            return CreatedAtRoute("GetCodeLookup", new { id = response.codeLookupId }, await _codeTableService.GetCodeLookupByIdAsync(response.codeLookupId));
        }

        [HttpGet("{id}", Name = "GetCodeLookup")]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<CodeLookupDto>> GetCodeLookupByIdAsync(decimal id)
        {
            var codeLookup = await _codeTableService.GetCodeLookupByIdAsync(id);
            if (codeLookup == null)
            {
                return NotFound();
            }

            return codeLookup;
        }
    }
}
