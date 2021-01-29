using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos.Note;
using Crt.Model.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface INoteService
    {
        Task<(decimal noteId, Dictionary<string, List<string>> errors)> CreateNoteAsync(NoteCreateDto note);
    }

    public class NoteService : CrtServiceBase, INoteService
    {
        private IProjectRepository _projectRepo;
        private INoteRepository _noteRepo;

        public NoteService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork,
             IProjectRepository projectRepo, INoteRepository noteRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _projectRepo = projectRepo;
            _noteRepo = noteRepo;
        }

        public async Task<(decimal noteId, Dictionary<string, List<string>> errors)> CreateNoteAsync(NoteCreateDto note)
        {
            note.TrimStringFields();

            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(Entities.Note, note, errors);

            await ValidateNote(note, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtnote = await _noteRepo.CreateNoteAsync(note);

            _unitOfWork.Commit();

            return (crtnote.NoteId, errors);
        }

        private async Task ValidateNote(NoteSaveDto note, Dictionary<string, List<string>> errors)
        {
            var project = await _projectRepo.GetProjectAsync(note.ProjectId);

            if (project == null)
            {
                errors.AddItem(Fields.ProjectId, $"Project ID [{note.ProjectId}] does not exist.");
            }

            if (!_currentUser.UserInfo.RegionIds.Contains(project.RegionId))
            {
                errors.AddItem(Fields.RegionId, $"Unauthorized to add note to the project [{note.ProjectId}] with region [{project.RegionId}]");
            }

            if (note.NoteType != NoteTypes.Emr && note.NoteType != NoteTypes.Status)
            {
                errors.AddItem(Fields.NoteType, $"Invalid note type [{note.NoteType}]");
            }
        }
    }
}
