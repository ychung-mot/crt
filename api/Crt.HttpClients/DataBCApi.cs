using Crt.HttpClients.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

namespace Crt.HttpClients
{
    public interface IDataBCApi
    {
        Task<string> GetPolygonOfInterestForElectoralDistrict(string boundingBox);
        Task<string> GetPolygonOfInterestForEconomicRegion(string boundingBox);
    }

    public class DataBCApi : IDataBCApi
    {
        private HttpClient _client;
        private IApi _api;
        private string _path;
        private ILogger<IDataBCApi> _logger;

        public DataBCApi(HttpClient client, IApi api, IConfiguration config, ILogger<IDataBCApi> logger)
        {
            _client = client;
            _api = api;
            _path = config.GetValue<string>("DataBC:Path");
            _logger = logger;
        }

        public async Task<string> GetPolygonOfInterestForElectoralDistrict(string boundingBox)
        {
            var query = _path + $"?service=WFS&version=2.0.0&request=GetFeature" +
                $"&typeName=pub:WHSE_ADMIN_BOUNDARIES.EBC_PROV_ELECTORAL_DIST_SVW&srsName=EPSG:4326&BBOX={boundingBox},EPSG:4326";

            var content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

            var results = JsonSerializer.Deserialize<FeatureCollection<decimal[]>>(content);

            return null;
        }

        public async Task<string> GetPolygonOfInterestForEconomicRegion(string boundingBox)
        {
            var query = _path + $"?service=WFS&version=2.0.0&request=GetFeature" + 
                $"&typeName=pub:WHSE_HUMAN_CULTURAL_ECONOMIC.CEN_ECONOMIC_REGIONS_SVW&srsName=EPSG:4326&BBOX={boundingBox},EPSG:4326";

            var content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

            var results = JsonSerializer.Deserialize<FeatureCollection<decimal[]>>(content);

            return null;
        }
    }
}
