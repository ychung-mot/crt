using System;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Note
{
    public class NoteDto
    {
        [JsonPropertyName("id")]
        public decimal NoteId { get; set; }
        public string NoteType { get; set; }
        public string Comment { get; set; }
        public decimal ProjectId { get; set; }
        public string UserId { get; set; }
        public DateTime NoteDate { get; set; }
        public bool CanDelete { get => true; }
    }
}
