using Crt.Api.Controllers.Base;
using Crt.HttpClients;
using Crt.Model;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Crt.Api.Controllers
{
    [ApiVersion("1.0")]
    [Route("api/spatial")]
    [ApiController]
    public class SpatialController : CrtControllerBase
    {
        private IRouterApi _routerApi;

        public SpatialController(CrtCurrentUser currentUser, IRouterApi routerApi)
            : base(currentUser)
        {
            _routerApi = routerApi;
        }

        [HttpGet("router")]
        public async Task<ActionResult<string>> GetRouteAsync(string criteria, string points, bool roundTrip)
        {
            var res = await _routerApi.GetRouteAsync(criteria, points, roundTrip);

            return Ok(res);
        }
    }
}
