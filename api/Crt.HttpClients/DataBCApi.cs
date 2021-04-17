using Crt.HttpClients.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using NetTopologySuite.Geometries;
using NetTopologySuite.Simplify;
using System.Collections.Generic;

namespace Crt.HttpClients
{
    public interface IDataBCApi
    {
        Task<List<Boundary>> GetPolygonOfInterestForElectoralDistrict(string boundingBox);
        Task<List<Boundary>> GetPolygonOfInterestForEconomicRegion(string boundingBox);
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

        public async Task<List<Boundary>> GetPolygonOfInterestForElectoralDistrict(string boundingBox)
        {
            List<Boundary> boundaries = new List<Boundary>(); 
            
            var query = _path + $"service=WFS&version=2.0.0&request=GetFeature&outputFormat=application/json" +
                $"&typeName=pub:WHSE_ADMIN_BOUNDARIES.EBC_PROV_ELECTORAL_DIST_SVW&srsName=EPSG:4326&BBOX={boundingBox},EPSG:4326";

            var content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

            var reader = new NetTopologySuite.IO.GeoJsonReader();
            var featureCollection = reader.Read<GeoJSON.Net.Feature.FeatureCollection>(content);
            if (featureCollection == null)
                return null;

            foreach (GeoJSON.Net.Feature.Feature feature in featureCollection.Features)
            {
                var polygon = feature.Geometry as GeoJSON.Net.Geometry.Polygon;
                var coordinates = new List<Coordinate>();
                foreach (var ring in polygon.Coordinates)
                {
                    foreach (var coordinate in ring.Coordinates)
                    {
                        coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
                    }
                }

                var polygonGeom = new Polygon(new LinearRing(coordinates.ToArray()));
                var geometry = TopologyPreservingSimplifier.Simplify(polygonGeom, 0.005);

                boundaries.Add(new Boundary
                {
                    NTSGeometry = geometry,
                    Name = (string)feature.Properties["ED_ABBREVIATION"],
                    Number = feature.Properties["ELECTORAL_DISTRICT_ID"].ToString()
                });
            }

            return boundaries;
        }

        public async Task<List<Boundary>> GetPolygonOfInterestForEconomicRegion(string boundingBox)
        {
            List<Boundary> boundaries = new List<Boundary>();

            var query = _path + $"service=WFS&version=2.0.0&request=GetFeature&outputFormat=application/json" + 
                $"&typeName=pub:WHSE_HUMAN_CULTURAL_ECONOMIC.CEN_ECONOMIC_REGIONS_SVW&srsName=EPSG:4326&BBOX={boundingBox},EPSG:4326";

            var content = await (await _api.Get(_client, query)).Content.ReadAsStringAsync();

            var reader = new NetTopologySuite.IO.GeoJsonReader();
            var featureCollection = reader.Read<GeoJSON.Net.Feature.FeatureCollection>(content);
            if (featureCollection == null)
                return null;

            foreach (GeoJSON.Net.Feature.Feature feature in featureCollection.Features)
            {
                var polygon = feature.Geometry as GeoJSON.Net.Geometry.Polygon;
                var coordinates = new List<Coordinate>();
                foreach (var ring in polygon.Coordinates)
                {
                    foreach (var coordinate in ring.Coordinates)
                    {
                        coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
                    }
                }

                var polygonGeom = new Polygon(new LinearRing(coordinates.ToArray()));
                var geometry = TopologyPreservingSimplifier.Simplify(polygonGeom, 0.005);

                boundaries.Add(new Boundary
                {
                    NTSGeometry = geometry,
                    Name = (string)feature.Properties["ECONOMIC_REGION_NAME"],
                    Number = feature.Properties["ECONOMIC_REGION_ID"].ToString()
                });
            }

            return boundaries;
        }
    }
}
