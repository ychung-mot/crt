using Crt.HttpClients.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;


namespace Crt.HttpClients
{
    public interface IGeoServerApi
    {
    }

    public class GeoServerApi : IGeoServerApi
    {
        private HttpClient _client;
        private GeoServerQueries _queries;
        private IApi _api;
        private string _path;
        private ILogger<IGeoServerApi> _logger;

        public GeoServerApi(HttpClient client, IApi api, IConfiguration config, ILogger<IGeoServerApi> logger)
        {
            _client = client;
            _queries = new GeoServerQueries();
            _api = api;
            _path = config.GetValue<string>("GeoServer:Path");
            _logger = logger;
        }

        public async Task<bool> GetSegmentLength(string lineString)
        {
            var body = string.Format(_queries.LineWithinPolygonQuery, lineString);

            var contents = await (await _api.PostWithRetry(_client, _path, body)).Content.ReadAsStringAsync();

            var features = JsonSerializer.Deserialize<FeatureCollection<decimal[]>>(contents);

            return features.numberMatched > 0;
        }
    }
}
