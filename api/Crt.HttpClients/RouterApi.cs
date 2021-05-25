using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Threading.Tasks;

namespace Crt.HttpClients
{
    public interface IRouterApi
    {
        public Task<string> GetRouteAsync(string criteria, string points, bool roundTrip);
    }
    public class RouterApi: IRouterApi
    {
        private HttpClient _client;
        private IApi _api;
        private string _apiKey;
        private ILogger<IRouterApi> _logger;

        public RouterApi(HttpClient client, IApi api, IConfiguration config, ILogger<IRouterApi> logger)
        {
            _client = client;
            _api = api;
            _apiKey = config.GetValue<string>("Router:ApiKey");
            _logger = logger;
        }

        public async Task<string> GetRouteAsync(string criteria, string points, bool roundTrip)
        {
            var query = $"directions.json?criteria={criteria}&points={points}&roundTrip={roundTrip}&apikey={_apiKey}";

            var content = await(await _api.Get(_client, query)).Content.ReadAsStringAsync();

            return content;
        }
    }
}
