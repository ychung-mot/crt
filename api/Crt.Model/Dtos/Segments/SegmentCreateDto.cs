using Crt.HttpClients.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Segments
{
    public class SegmentCreateDto
    {
        public decimal ProjectId { get; set; }
        public decimal[][] Route { get; set; }
        public string Description { get; set; }
    }
}