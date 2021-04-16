using NetTopologySuite.Geometries;
using System.Collections.Generic;

namespace Crt.Model.Utils
{
    public static class ArrayEnxtentions
    {
        public static Coordinate[] ToTopologyCoordinates(this decimal[][] points)
        {
            var coordinates = new List<Coordinate>();

            foreach (var point in points)
            {
                coordinates.Add(new Coordinate((double)point[0], (double)point[1]));
            }

            return coordinates.ToArray();
        }
    }
}
