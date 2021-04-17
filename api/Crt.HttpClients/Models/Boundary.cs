using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.HttpClients.Models
{
    public class Boundary
    {
        public NetTopologySuite.Geometries.Geometry NTSGeometry { get; set; }
        public string Name { get; set; }
        public string Number { get; set; }  //2 of them are int-32, 1 is int-64 and one is a string numeric
    }
}
