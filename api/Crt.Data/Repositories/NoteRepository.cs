using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model.Dtos.Note;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface INoteRepository
    {
        Task<CrtNote> CreateNoteAsync(NoteCreateDto note);
    }

    public class NoteRepository : CrtRepositoryBase<CrtNote>, INoteRepository
    {
        public NoteRepository(AppDbContext dbContext, IMapper mapper)
            : base(dbContext, mapper)
        {
        }

        public async Task<CrtNote> CreateNoteAsync(NoteCreateDto note)
        {
            var crtNote = new CrtNote();

            Mapper.Map(note, crtNote);

            await DbSet.AddAsync(crtNote);

            return crtNote;
        }
    }
}
