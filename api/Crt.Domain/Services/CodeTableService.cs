using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface ICodeTableService
    {
        Task<PagedDto<CodeLookupListDto>> GetCodeTablesAsync(string codeSet, string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
        Task<(decimal codeLookupId, Dictionary<string, List<string>> errors)> CreateCodeLookupAsync(CodeLookupCreateDto codeLookup);
        Task<CodeLookupDto> GetCodeLookupByIdAsync(decimal codeLookupId);
        Task<(bool NotFound, Dictionary<string, List<string>> errors)> UpdateCodeLookupAsync(CodeLookupUpdateDto codeLookup);

        Task<(bool NotFound, Dictionary<string, List<string>> errors)> DeleteCodeLookupAsync(decimal id);
    }

    public class CodeTableService : CrtServiceBase, ICodeTableService
    {
        private ICodeLookupRepository _codeLookupRepo;
        
        public CodeTableService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork, 
            ICodeLookupRepository codeLookupRepo) : base(currentUser, validator, unitOfWork)
        {
            _codeLookupRepo = codeLookupRepo;
        }

        public Task<PagedDto<CodeLookupListDto>> GetCodeTablesAsync(string codeSet, string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            return _codeLookupRepo.GetCodeTablesAsync(codeSet, searchText, isActive, pageSize, pageNumber, orderBy, direction);
        }

        public async Task<CodeLookupDto> GetCodeLookupByIdAsync(decimal codeLookupId)
        {
            return await _codeLookupRepo.GetCodeLookupByIdAsync(codeLookupId);
        }

        public async Task<(decimal codeLookupId, Dictionary<string, List<string>> errors)> CreateCodeLookupAsync(CodeLookupCreateDto codeLookup)
        {
            codeLookup.TrimStringFields();
            
            var errors = new Dictionary<string, List<string>>();
            errors = _validator.Validate(Entities.CodeTable, codeLookup, errors);

            if (await _codeLookupRepo.DoesCodeLookupExistAsync(codeLookup.CodeName, codeLookup.CodeSet))
            {
                errors.AddItem(Fields.CodeLookup, $"Code Lookup [{codeLookup.CodeName}] in Code Set [{codeLookup.CodeSet}] already exists");
            }

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtCodeLookup = await _codeLookupRepo.CreateCodeLookupAsync(codeLookup);

            _unitOfWork.Commit();

            //need to reload the codelookup singleton
            _validator.CodeLookup = _codeLookupRepo.GetCodeLookups();

            return (crtCodeLookup.CodeLookupId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> errors)> UpdateCodeLookupAsync(CodeLookupUpdateDto codeLookup)
        {
            codeLookup.TrimStringFields();

            var crtCodeLookup = await _codeLookupRepo.GetCodeLookupByIdAsync(codeLookup.CodeLookupId);

            if (crtCodeLookup == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();
            errors = _validator.Validate(Entities.CodeTable, codeLookup, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _codeLookupRepo.UpdateCodeLookupAsync(codeLookup);

            _unitOfWork.Commit();

            //need to reload the codelookup singleton
            _validator.CodeLookup = _codeLookupRepo.GetCodeLookups();

            return (false, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> errors)> DeleteCodeLookupAsync(decimal id)
        {
            var errors = new Dictionary<string, List<string>>();

            var codeLookupFromDB = await GetCodeLookupByIdAsync(id);

            if (codeLookupFromDB == null)
            {
                return (true, null);
            }

            if (await _codeLookupRepo.IsCodeLookupInUseAsync(codeLookupFromDB.CodeLookupId))
            {
                errors.AddItem(Fields.CodeLookup, $"Code Lookup ID: [{codeLookupFromDB.CodeLookupId}], Name: [{codeLookupFromDB.CodeName}] is in use and cannot be deleted.");
            }

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _codeLookupRepo.DeleteCodeLookupAsync(id);

            _unitOfWork.Commit();

            //need to reload the codelookup singleton
            _validator.CodeLookup = _codeLookupRepo.GetCodeLookups();

            return (false, errors);
        }

        
    }
}
