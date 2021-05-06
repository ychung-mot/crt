using Crt.HttpClients.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using GJFeature = GeoJSON.Net.Feature;  // use an alias since Feature exists in HttpClients.Models

namespace Crt.HttpClients
{
    public interface IDataBCApi
    {
        Task<List<GeometryLayer>> GetPolygonOfInterestForElectoralDistrict(string boundingBox);
        Task<List<GeometryLayer>> GetPolygonOfInterestForEconomicRegion(string boundingBox);
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

        public async Task<List<GeometryLayer>> GetPolygonOfInterestForElectoralDistrict(string boundingBox)
        {
            List<GeometryLayer> layerPolygons = new List<GeometryLayer>();
            var query = "";
            var content = "";

            try
            {
                query = _path + $"service=WFS&version=2.0.0&request=GetFeature&outputFormat=application/json" +
                $"&typeName=pub:WHSE_ADMIN_BOUNDARIES.EBC_PROV_ELECTORAL_DIST_SVW&srsName=EPSG:4326&BBOX={boundingBox},EPSG:4326";

                content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

                var featureCollection = SpatialUtils.ParseJSONToFeatureCollection(content);
                //continue if we have a feature collection
                if (featureCollection != null)
                {
                    //iterate the features in the parsed geoJSON collection
                    foreach (GJFeature.Feature feature in featureCollection.Features)
                    {
                        var simplifiedGeom = SpatialUtils.GenerateSimplifiedPolygonGeometry(feature);

                        layerPolygons.Add(new GeometryLayer
                        {
                            NTSGeometry = simplifiedGeom,
                            Name = (string)feature.Properties["ED_ABBREVIATION"],
                            Number = feature.Properties["ELECTORAL_DISTRICT_ID"].ToString()
                        });
                    }
                }
            } catch (System.Exception ex)
            {
                _logger.LogError($"Exception {ex.Message} - GetPolygonOfInterestForElectoralDistrict({boundingBox}): {query} - {content}");
                throw;
            }

            return layerPolygons;
        }

        public async Task<List<GeometryLayer>> GetPolygonOfInterestForEconomicRegion(string boundingBox)
        {
            List<GeometryLayer> layerPolygons = new List<GeometryLayer>();
            var query = "";
            var content = "";

            try
            {
                query = _path + $"service=WFS&version=2.0.0&request=GetFeature&outputFormat=application/json" +
                $"&typeName=pub:WHSE_HUMAN_CULTURAL_ECONOMIC.CEN_ECONOMIC_REGIONS_SVW&srsName=EPSG:4326&BBOX={boundingBox},EPSG:4326";

                content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

                var featureCollection = SpatialUtils.ParseJSONToFeatureCollection(content);
                //continue if we have a feature collection
                if (featureCollection != null)
                {
                    //iterate the features in the parsed geoJSON collection
                    foreach (GJFeature.Feature feature in featureCollection.Features)
                    {
                        //override economic region distance tolerance, the polygons are huge and we need to 
                        // simplify them more
                        var simplifiedGeom = SpatialUtils.GenerateSimplifiedPolygonGeometry(feature);

                        layerPolygons.Add(new GeometryLayer
                        {
                            NTSGeometry = simplifiedGeom,
                            Name = (string)feature.Properties["ECONOMIC_REGION_NAME"],
                            Number = feature.Properties["ECONOMIC_REGION_ID"].ToString()
                        });
                    }
                }
            } catch (System.Exception ex)
            {
                _logger.LogError($"Exception {ex.Message} - GetPolygonOfInterestForEconomicRegion({boundingBox}): {query} - {content}");
                throw;
            }

            return layerPolygons;
        }
    }
}
