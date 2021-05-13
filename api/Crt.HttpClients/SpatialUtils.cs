using System.Collections.Generic;
using System.Linq;
using NetTopologySuite.Simplify;
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using GeoJSON.Net.Feature;
using System;
using GJNGeometry = GeoJSON.Net.Geometry;
using NetTopologySuite.Algorithm.Locate;

//kept in HttpClients project as it contains the GeoJSON and NetTopology references
namespace Crt.HttpClients
{
    public static class SpatialUtils
    {
        /// <summary>
        /// Utility function takes an array of coordinates and builds them 
        /// into a string with a limit of 250 coordinate pairs in a group. 
        /// The group is placed into a string array that is then returned 
        /// for processing.
        /// This is to deal with GeoServer only accepting a max of 500 
        /// coordinate pairs and also ensures we don't hit MAX post size.
        /// </summary>
        /// <param name="coordinates"></param>
        /// <returns></returns>
        public static List<string> BuildGeometryStringList(Coordinate[] coordinates)
        {
            var geometryGroup = new List<string>();
            var geometryLineString = "";
            var coordinateCount = 0;
            
            foreach (Coordinate coordinate in coordinates)
            {
                geometryLineString += coordinate.X + "\\," + coordinate.Y + "\\,";
                coordinateCount++;
                if (coordinateCount == 250 || (coordinate == coordinates.Last()))
                {
                    geometryGroup.Add(geometryLineString.Substring(0, geometryLineString.Length - 2));
                    geometryLineString = "";
                    coordinateCount = 0;
                }
            }

            if (coordinates.Count() > 1)
            {
                //check the last item to see if it's a single since the GeoServer queries expect
                // at least 2 pairs we'll need to make some adjustments if there is a group with 1 pair
                // this won't exceed the paramter limit since it's 1000 (500 pairs)
                var count = geometryGroup.Count();
                if (geometryGroup[count - 1].Count(g => g == ',') == 1)
                {
                    var lastGroup = geometryGroup[count - 1];
                    var secondLastGroup = geometryGroup[count - 2];
                    secondLastGroup += "\\," + lastGroup;   //append the previously last group to the 2nd last group text
                    geometryGroup[count - 2] = secondLastGroup; //update the second last group
                    geometryGroup.RemoveAt(count - 1);  //remove the last group
                }
            }

            return geometryGroup;
        }

        public static string BuildGeometryString(Coordinate[] coordinates)
        {
            string geometryString = "";
            var isPoint = (coordinates.Length == 1);

            foreach (Coordinate coordinate in coordinates)
            {
                geometryString += coordinate.X + "\\," + coordinate.Y;
                if (coordinate != coordinates.Last())
                {
                    geometryString += "\\,";
                }
            }

            //geometry strings being used in the line within polygon requires 2 points or the query throws an error
            // so we'll double up the coordinates making the line start and end at the same point
            if (isPoint)
                geometryString += "\\," + geometryString;

            return geometryString;
        }

        public static Geometry GenerateSimplifiedPolygonGeometryFromMultilineString(Feature feature, double distanceTolerance = 0.001)
        {
            Geometry geometry;

            /// See GenerateSimplifiedPolygonGeometry for more comments on what is happening in the simplify process
            var multilineString = feature.Geometry as GeoJSON.Net.Geometry.MultiLineString;
            var coordinates = new List<Coordinate>();
            List<LineString> lineStrings = new List<LineString>();

            foreach (var line in multilineString.Coordinates)
            {
                foreach (var coordinate in line.Coordinates)
                {
                    coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
                }
                lineStrings.Add(new LineString(coordinates.ToArray()));
            }

            MultiLineString mls = new MultiLineString(lineStrings.ToArray());
            var polygonGeom = mls.Buffer(0.003) as Polygon;

            polygonGeom.Normalize();

            do
            {
                geometry = TopologyPreservingSimplifier.Simplify(polygonGeom, distanceTolerance);
                distanceTolerance += 0.001;
            } while (geometry.Coordinates.Length > 500);

            return geometry;
        }

        public static Geometry GenerateSimplifiedPolygonGeometryFromLineString(Feature feature, double distanceTolerance = 0.001)
        {
            /// See GenerateSimplifiedPolygonGeometry for more comments on what is happening in the simplify process
            Geometry geometry;

            var lineString = feature.Geometry as GeoJSON.Net.Geometry.LineString;
            var coordinates = new List<Coordinate>();
            
            foreach (var coordinate in lineString.Coordinates)
            {
                coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
            }

            LineString ls = new LineString(coordinates.ToArray());
            
            var polygonGeom = ls.Buffer(0.003) as Polygon;

            polygonGeom.Normalize();

            do
            {
                geometry = TopologyPreservingSimplifier.Simplify(polygonGeom, distanceTolerance);
                distanceTolerance += 0.001;
            } while (geometry.Coordinates.Length > 500);

            return geometry;
        }

        public static LineString GenerateLineString(Feature feature)
        {
            var lineString = feature.Geometry as GeoJSON.Net.Geometry.LineString;
            var coordinates = new List<Coordinate>();

            foreach (var coordinate in lineString.Coordinates)
            {
                coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
            }

            //LineString ls = new LineString(coordinates.ToArray());

            return new LineString(coordinates.ToArray());
        }

        public static MultiLineString GenerateMultiLineString(Feature feature)
        {
            var multilineString = feature.Geometry as GeoJSON.Net.Geometry.MultiLineString;
            var coordinates = new List<Coordinate>();
            List<LineString> lineStrings = new List<LineString>();

            foreach (var line in multilineString.Coordinates)
            {
                foreach (var coordinate in line.Coordinates)
                {
                    coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
                }
                lineStrings.Add(new LineString(coordinates.ToArray()));
            }

            return new MultiLineString(lineStrings.ToArray());

            //return mls;
        }

        public static double CalculateDistance(Geometry coordinates)
        {
            const double _m2km = 1.609344;

            var totalDistance = 0.0;

            if (coordinates.Coordinates.Length > 0)
            {
                if (coordinates.GeometryType == Geometry.TypeNamePoint)
                {
                    totalDistance = 0.0001;
                } else
                {
                    var startCoord = coordinates.Coordinates[0]; //first coordinate

                    foreach (var coord in coordinates.Coordinates)
                    {
                        var p1Lat = startCoord.Y;
                        var p1Lon = startCoord.X;

                        var p2Lat = coord.Y;
                        var p2Lon = coord.X;


                        double theta = p1Lon - p2Lon;
                        //determine the distance between the 2 coordinate points using solution of spherical triangles
                        // cos a = sin b * sin c + cos b * cos c * cos A
                        // b is latitude (to radians) of point 1
                        // c is latidude (to radians) of point 2
                        // A is difference in meridians of the longtitude of both points (to radians)
                        double _b = DegreesToRadians(p1Lat);
                        double _c = DegreesToRadians(p2Lat);
                        double _A = DegreesToRadians(theta);
                        double _a = Math.Sin(_b) * Math.Sin(_c) + Math.Cos(_b) * Math.Cos(_c) * Math.Cos(_A);

                        //angle of the cosine into radians
                        double distance = Math.Acos(_a);
                        //turn the radians back into degrees
                        distance = RadiansToDegress(distance);
                        //one minute of degrees equals 1.1515 miles so degrees * 1 hour (60 minutes) * 1 mile (1.1515)
                        distance = distance * 60 * 1.1515;
                        //convert to KM, could convert to nautical miles using 0.8684
                        distance = distance * _m2km;

                        totalDistance += (Double.IsNaN(distance)) ? 0 : distance;
                        startCoord = coord;
                    }
                }
            }

            return totalDistance;
        }

        public static double DegreesToRadians(double degrees)
        {
            return degrees * Math.PI / 180.0;
        }

        public static double RadiansToDegress(double radians)
        {
            return radians / Math.PI * 180.0;
        }

        public static Geometry LineCordinatesWithinPolygon(Geometry polygon, Geometry lineString)
        {
            var coordinates = new List<Coordinate>();
            Geometry geometryWithinPolygon = null;

            //generate a new area locatory using the polygon
            var pointLocator = new IndexedPointInAreaLocator(polygon);

            //check that our linestring actually has coordinates
            if (lineString.Coordinates.Length > 0)
            {
                //iterate thru the coordinates in the linestring
                foreach (var coord in lineString.Coordinates)
                {
                    //use the point locator to locate our coordinates
                    var location = pointLocator.Locate(coord);
                    // is the location of the coordinate outside the polygon?
                    var isInside = !location.HasFlag(Location.Exterior);

                    //if coords are inside polygon add to list
                    if (isInside)
                        coordinates.Add(coord);
                }

                //validate list actually has coordinates
                if (coordinates.Count > 0)
                {
                    //if we have more than one set of coordinates we have a line, otherwise it's a point
                    geometryWithinPolygon = (coordinates.Count > 1) ? Geometry.DefaultFactory.CreateLineString(coordinates.ToArray())
                        : Geometry.DefaultFactory.CreatePoint(coordinates[0]);
                }
            }

            return geometryWithinPolygon;
        }

        public static Geometry GenerateNTSPolygonGeometery(Feature feature)
        {
            //  cast the feature geometry as a GeoJSON Polygon
            var polygon = feature.Geometry as GeoJSON.Net.Geometry.Polygon;
            var coordinates = new List<Coordinate>();

            foreach (var ring in polygon.Coordinates)
            {
                foreach (var coordinate in ring.Coordinates)
                {
                    coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
                }
            }

            //generate the new NTS polygon & linear ring
            var polygonGeom = new Polygon(new LinearRing(coordinates.ToArray()));

            //normalize the polygon, converting it to the canonical form and ordering the 
            // coordinates within, this will help smooth the simplification process creating
            // less holes/overlap
            polygonGeom.Normalize();

            return polygonGeom;
        }

        public static Geometry GenerateSimplifiedPolygonGeometry(Feature feature, double distanceTolerance = 0.001)
        {
            //* we'll pull out the rings and coordinates out and create a new collection
            //* of coordinates that we can then put into a NetTopology geometry object
            
            Geometry geometry;
            
            //  cast the feature geometry as a GeoJSON Polygon
            var polygon = feature.Geometry as GeoJSON.Net.Geometry.Polygon;
            var coordinates = new List<Coordinate>();

            foreach (var ring in polygon.Coordinates)
            {
                foreach (var coordinate in ring.Coordinates)
                {
                    coordinates.Add(new Coordinate(coordinate.Longitude, coordinate.Latitude));
                }
            }

            //generate the new NTS polygon & linear ring
            var polygonGeom = new Polygon(new LinearRing(coordinates.ToArray()));

            //normalize the polygon, converting it to the canonical form and ordering the 
            // coordinates within, this will help smooth the simplification process creating
            // less holes/overlap
            polygonGeom.Normalize();

            //we need the number of geomeotric pairs to be under 500 as there is a 1000 parameter limit on 
            // the GeoServer Oracle DB. We'll do the simplification and then adjust the distance tolerance
            // until this achieved
            do
            {
                //while DouglasPeucker is faster, topologypreserving works better for irregular shaped polygons
                /*var geometry = DouglasPeuckerSimplifier.Simplify(polygonGeom, 0.005);*/
                
                // the tolerance is how far from the original the simplification can be done, in Meters 
                // Lower number will result in more coordinates but closer representation of the original shape
                geometry = TopologyPreservingSimplifier.Simplify(polygonGeom, distanceTolerance);
                distanceTolerance += 0.001;
            } while (geometry.Coordinates.Length > 500);

            return geometry;
        }

        public static FeatureCollection ParseJSONToFeatureCollection(string jsonContent)
        {
            //create NTS JSON reader
            var reader = new GeoJsonReader();

            // pass the geoJSON to the reader and cast return to FeatureCollection
            var fc = reader.Read<FeatureCollection>(jsonContent);

            // fail out if no featureCollection
            if (fc == null)
                return null;
            else
                return fc;
        }
    }
}
