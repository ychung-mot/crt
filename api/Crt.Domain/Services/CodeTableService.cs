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

            //await ValidateFinTarget(finTarget, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtCodeLookup = await _codeLookupRepo.CreateCodeLookupAsync(codeLookup);

            _unitOfWork.Commit();

            return (crtCodeLookup.CodeLookupId, errors);
        }
    }
}
