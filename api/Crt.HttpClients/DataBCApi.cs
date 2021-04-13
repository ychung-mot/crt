using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.Results;

namespace Crt.HttpClients
{
    public interface IDataBCApi
    {
    }

    public class DataBCApi : IDataBCApi
    {
        private HttpClient _client;
        private GeoServerQueries _queries;
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

        public async Task<string> GetElectoralDistrictPolygon(string bboxString)
        {
            var query = $"?service=WFS&version=2.0.0&request=GetFeature" +
                $"&typeName=pub:WHSE_ADMIN_BOUNDARIES.EBC_PROV_ELECTORAL_DIST_SVW&srsName=EPSG:4326&BBOX={bboxString},EPSG:4326";

            var content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

            return content;
        }

        public async Task<string> GetEconomicRegionPolygon(string bboxString)
        {
            var query = $"?service=WFS&version=2.0.0&request=GetFeature" + 
                $"&typeName=pub:WHSE_HUMAN_CULTURAL_ECONOMIC.CEN_ECONOMIC_REGIONS_SVW&srsName=EPSG:4326&BBOX={bboxString},EPSG:4326";

            var content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

            return content;
        }
    }
}
