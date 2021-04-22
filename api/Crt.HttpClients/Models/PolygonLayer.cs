using NTSGeometry = NetTopologySuite.Geometries;

namespace Crt.HttpClients.Models
{
    public class PolygonLayer
    {
        public NTSGeometry.Geometry NTSGeometry { get; set; }
        public string Name { get; set; }
        public string Number { get; set; }  //2 of them are int-32, 1 is int-64 and one is a string numeric
    }
}
