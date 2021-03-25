using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Note
{
    public class NoteUpdateDto : NoteSaveDto
    {
        [JsonPropertyName("id")]
        public decimal NoteId { get; set; }
    }
}
