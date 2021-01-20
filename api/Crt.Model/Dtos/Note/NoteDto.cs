using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Model.Dtos.Note
{
    public class NoteDto
    {
        public decimal NoteId { get; set; }
        public string NoteType { get; set; }
        public string Comment { get; set; }
        public decimal ProjectId { get; set; }
        public string UserId { get; set; }
        public DateTime NoteDate { get; set; }
    }
}
