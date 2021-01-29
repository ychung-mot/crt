namespace Crt.Model.Dtos.Note
{
    public class NoteSaveDto
    {
        public string NoteType { get; set; }
        public string Comment { get; set; }
        public decimal ProjectId { get; set; }
    }
}
