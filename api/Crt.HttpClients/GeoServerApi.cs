using Crt.HttpClients.Models;
using Crt.Model.Utils;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using NetTopologySuite.Geometries;
using NetTopologySuite.Simplify;

namespace Crt.HttpClients
{
    public interface IGeoServerApi
    {
        Task<double> GetSegmentLength(string lineString);
        Task<string> GetProjectExtent(decimal projectId);
        Task<List<Boundary>> GetPolygonOfInterestForServiceArea(string boundingBox);
        Task<List<Boundary>> GetPolygonOfInterestForDistrict(string boundingBox);
        HttpClient Client { get; }
        public string Path { get; }
    }

    public class GeoServerApi : IGeoServerApi
    {
        public HttpClient Client { get; private set; }
        public string Path { get; private set; }
        private GeoServerQueries _queries;
        private IApi _api;
        private ILogger<IGeoServerApi> _logger;

        private const string DEFAULT_POLYXY = "-140.58\\,47.033";   //it's in the ocean 
        private const string DEFAULT_SRID = "4326";

        public GeoServerApi(HttpClient client, IApi api, IConfiguration config, ILogger<IGeoServerApi> logger)
        {
            Client = client;
            _queries = new GeoServerQueries();
            _api = api;

            var env = config.GetEnvironment();
            Path = config.GetValue<string>($"GeoServer{env}:Path");
            _logger = logger;
        }

        public async Task<double> GetSegmentLength(string lineString)
        {

            
            double totalLength = 0;

            var body = string.Format(_queries.LineWithinPolygonQuery, DEFAULT_SRID, lineString, DEFAULT_SRID, DEFAULT_POLYXY);

            var content = await (await _api.PostWithRetry(Client, Path, body)).Content.ReadAsStringAsync();

            var results = JsonSerializer.Deserialize<FeatureCollection<object>>(content);

            foreach (var feature in results.features)
            {
                totalLength += feature.properties.COMPLETE_LENGTH_KM;
            }
           
            return totalLength;
        }

        public async Task<string> GetProjectExtent(decimal projectId)
        {
            var query = Path + string.Format(_queries.BoundingBoxForProject, projectId);

            var content = await (await _api.GetWithRetry(Client, query)).Content.ReadAsStringAsync();

            var results = JsonSerializer.Deserialize<FeatureCollection<object>>(content);

            return string.Join(",", results.bbox);
        }

        public async Task<List<Boundary>> GetPolygonOfInterestForServiceArea(string boundingBox)
        {
            List<Boundary> boundaries = new List<Boundary>();

            var query = Path + string.Format(_queries.PolygonOfInterest, "hwy:DSA_CONTRACT_AREA", boundingBox);

            var content = await (await _api.GetWithRetry(Client, query)).Content.ReadAsStringAsync();

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
                    Name = (string)feature.Properties["CONTRACT_AREA_NAME"],
                    Number = feature.Properties["CONTRACT_AREA_NUMBER"].ToString()
                });
            }

            return boundaries;
        }

        public async Task<List<Boundary>> GetPolygonOfInterestForDistrict(string boundingBox)
        {
            List<Boundary> boundaries = new List<Boundary>();

            var query = Path + string.Format(_queries.PolygonOfInterest, "hwy:DSA_DISTRICT_BOUNDARY", boundingBox);

            var content = await (await _api.GetWithRetry(Client, query)).Content.ReadAsStringAsync();

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
                    Name = (string)feature.Properties["DISTRICT_NAME"],
                    Number = feature.Properties["DISTRICT_NUMBER"].ToString()
                });
            }

            return boundaries;
        }
    }
}
