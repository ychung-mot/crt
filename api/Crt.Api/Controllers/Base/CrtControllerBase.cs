using Crt.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Crt.Api.Controllers.Base
{
    public class CrtControllerBase : ControllerBase
    {
        protected CrtCurrentUser _currentUser;

        public CrtControllerBase(CrtCurrentUser currentUser)
        {
            _currentUser = currentUser;
        }

        protected ValidationProblemDetails IsRegionIdAuthorized(decimal regionId)
        {
            if (!_currentUser.UserInfo.RegionIds.Contains(regionId))
            {
                var problem = new ValidationProblemDetails()
                {
                    Type = "https://crt.bc.gov.ca/exception",
                    Title = "Access denied (Region)",
                    Status = StatusCodes.Status401Unauthorized,
                    Detail = "Insufficient permission.",
                    Instance = HttpContext.Request.Path
                };

                problem.Extensions.Add("traceId", HttpContext.TraceIdentifier);

                return problem;
            }

            return null;
        }

        protected ValidationProblemDetails AreRegionIdsAuthorized(decimal[] regionIds)
        {
            var illegalRegions = new List<decimal>();

            foreach (var regionId in regionIds)
            {
                if (!_currentUser.UserInfo.RegionIds.Any(x => x == regionId))
                {
                    illegalRegions.Add(regionId);
                }
            }

            if (illegalRegions.Count == 0)
            {
                return null;
            }

            var message = new StringBuilder("User doesn't have access to the region(s) - ");


            foreach (var number in illegalRegions)
            {
                message.Append($"{number}, ");
            }

            var problem = new ValidationProblemDetails()
            {
                Type = "https://crt.bc.gov.ca/model-validation-error",
                Title = "Access denied",
                Status = StatusCodes.Status422UnprocessableEntity,
                Detail = message.ToString().Trim().TrimEnd(','),
                Instance = HttpContext.Request.Path
            };

            problem.Extensions.Add("traceId", HttpContext.TraceIdentifier);

            return problem;
        }
    }
}
