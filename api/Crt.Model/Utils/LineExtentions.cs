using Crt.HttpClients.Models;
using NetTopologySuite.Geometries;
using System.Collections.Generic;

namespace Crt.Model.Utils
{
    public static class LineExtentions
    {
        public static Coordinate[] ToTopologyCoordinates(this Line line)
        {
            var coordinates = new List<Coordinate>();

            foreach(var point in line.Points)
            {
                coordinates.Add(point.ToTopologyCoordinate());
            }

            return coordinates.ToArray();
        }

        public static Coordinate[] ToTopologyCoordinates(this decimal[][] points)
        {
            var coordinates = new List<Coordinate>();

            foreach (var point in points)
            {
                coordinates.Add(new Coordinate((double)point[0], (double) point[1]));
            }

            return coordinates.ToArray();
        }
    }
}
