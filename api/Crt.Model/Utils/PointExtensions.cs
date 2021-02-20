using NetTopologySuite.Geometries;

namespace Crt.Model.Utils
{
    public static class PointExtensions
    {
        public static Coordinate ToTopologyCoordinate(this Crt.HttpClients.Models.Point point)
        {
            return new Coordinate((double)point.Longitude, (double)point.Latitude);
        }
    }
}
