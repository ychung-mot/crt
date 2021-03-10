using Crt.Data.Repositories;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
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
    }

    public class CodeTableService : ICodeTableService
    {
        private ICodeLookupRepository _codeLookupRepo;

        public CodeTableService(ICodeLookupRepository codeLookupRepo)
        {
            _codeLookupRepo = codeLookupRepo;
        }

        public Task<PagedDto<CodeLookupListDto>> GetCodeTablesAsync(string codeSet, string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            return _codeLookupRepo.GetCodeTablesAsync(codeSet, searchText, isActive, pageSize, pageNumber, orderBy, direction);
        }
    }
}
