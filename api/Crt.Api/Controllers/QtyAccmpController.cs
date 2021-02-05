using Crt.Api.Authorization;
using Crt.Api.Controllers.Base;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Element;
using Crt.Model.Dtos.FinTarget;
using Crt.Model.Dtos.QtyAccmp;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/projects/{projectId}/qtyaccmps")]
    [ApiController]
    public class QtyAccmpController : CrtControllerBase
    {
        private IQtyAccmpService _qtyAccmpService;

        public QtyAccmpController(CrtCurrentUser currentUser, IQtyAccmpService qtyAccmpService)
            : base(currentUser)
        {
            _qtyAccmpService = qtyAccmpService;
        }

        [HttpGet]
        [RequiresPermission(Permissions.ProjectRead)]
        public async Task<ActionResult<QtyAccmpDto>> GetQtyAccmpIdAsync(decimal qtyAccmpId)
        {
            //var qtyAccmp = await _qtyAccmpService.GetQtyAccmpAsync(qtyAccmpId);

            //if (qtyAccmp == null)
            //{
            //    return NotFound();
            //}

            //var problem = IsRegionIdAuthorized(regionId);
            //if (problem != null)
            //{
            //    return Unauthorized(problem);
            //}

            #region Mockup
            await Task.CompletedTask;

            var qtyAccmp = new QtyAccmpDto {
                QtyAccmpId = 1,
                ProjectId = 1,
                Forecast = 52,
                Schedule7 = 68,
                Actual = 75,
                Comment = "Test accomplishment comment",

                FiscalYearLkup = new CodeLookupDto
                {
                    CodeLookupId = 362,
                    CodeSet = CodeSet.FiscalYear,
                    CodeName = "2020/2021",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 11
                },

                QtyAccmpLkup = new CodeLookupDto
                {
                    CodeLookupId = 370,
                    CodeSet = CodeSet.Quantity,
                    CodeName = "Asphalt Mix  (tonnes)",
                    CodeValueText = "",
                    CodeValueNum = null,
                    CodeValueFormat = "STRING",
                    DisplayOrder = 1
                },
            };

            return Ok(qtyAccmp);
            #endregion
        }
    }
}
