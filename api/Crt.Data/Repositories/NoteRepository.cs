using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.Note;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface INoteRepository
    {
        Task<List<NoteDto>> GetNotesAsync(decimal projectId);
        Task<NoteDto> GetNoteByIdAsync(decimal noteId);
        Task<CrtNote> CreateNoteAsync(NoteCreateDto note);
        Task UpdateNoteAsync(NoteUpdateDto note);
        Task DeleteNoteAsync(decimal noteId);
    }

    public class NoteRepository : CrtRepositoryBase<CrtNote>, INoteRepository
    {
        public NoteRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<List<NoteDto>> GetNotesAsync(decimal projectId)
        {
            var crtNotes = await DbSet.AsNoTracking()
                .Where(x => x.ProjectId == projectId)
                .ToListAsync();

            var notes = Mapper.Map<List<NoteDto>>(crtNotes);

            foreach (var note in notes)
            {
                var user = await DbContext.CrtSystemUsers
                    .FirstOrDefaultAsync(x => x.Username == note.UserId);

                note.UserName = user == null ? note.UserId : $"{user.LastName}, {user.FirstName}";
            }

            return notes;
        }

        public async Task<NoteDto> GetNoteByIdAsync(decimal noteId)
        {
            var note = await DbSet.AsNoTracking()
                        .FirstOrDefaultAsync(x => x.NoteId == noteId);

            return Mapper.Map<NoteDto>(note);
        }

        public async Task<CrtNote> CreateNoteAsync(NoteCreateDto note)
        {
            var crtNote = new CrtNote();

            Mapper.Map(note, crtNote);

            await DbSet.AddAsync(crtNote);

            return crtNote;
        }

        public async Task UpdateNoteAsync(NoteUpdateDto note)
        {
            var crtNote = await DbSet.FirstAsync(x => x.NoteId == note.NoteId);

            Mapper.Map(note, crtNote);
        }

        public async Task DeleteNoteAsync(decimal noteId)
        {
            var crtNote = await DbSet.FirstAsync(x => x.NoteId == noteId);

            DbSet.Remove(crtNote);
        }
    }
}
