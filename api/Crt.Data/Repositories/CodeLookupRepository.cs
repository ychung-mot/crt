using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface ICodeLookupRepository
    {
        IEnumerable<CodeLookupDto> GetCodeLookups();
        Task<PagedDto<CodeLookupListDto>> GetCodeTablesAsync(string codeSet, string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
        Task<CrtCodeLookup> CreateCodeLookupAsync(CodeLookupCreateDto codeLookup);
        Task<CodeLookupDto> GetCodeLookupByIdAsync(decimal codeLookupId);
        Task UpdateCodeLookupAsync(CodeLookupUpdateDto codeLookup);
    }

    public class CodeLookupRepository : CrtRepositoryBase<CrtCodeLookup>, ICodeLookupRepository
    {
        public CodeLookupRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public IEnumerable<CodeLookupDto> GetCodeLookups()
        {
            return GetAllNoTrack<CodeLookupDto>(x => x.EndDate == null || DateTime.Today < x.EndDate);
        }

        public async Task<PagedDto<CodeLookupListDto>> GetCodeTablesAsync(string codeSet,
            string searchText, bool? isActive,
            int pageSize, int pageNumber, string orderBy, string direction)
        {
            var query = DbSet.AsNoTracking();

            query = query.Where(x => x.CodeSet == codeSet);

            if (searchText.IsNotEmpty())
            {
                query = query
                    .Where(x => x.CodeValueText.Contains(searchText) || x.CodeName.Contains(searchText));
            }

            if (isActive != null)
            {
                query = (bool)isActive
                    ? query.Where(x => x.EndDate == null || x.EndDate > DateTime.Today)
                    : query.Where(x => x.EndDate != null && x.EndDate <= DateTime.Today);
            }

            var results = await Page<CrtCodeLookup, CodeLookupListDto>(query, pageSize, pageNumber, orderBy, direction);

            return results;

        }

        public async Task<CrtCodeLookup> CreateCodeLookupAsync(CodeLookupCreateDto codeLookup)
        {
            var crtCodeLookup = new CrtCodeLookup();

            Mapper.Map(codeLookup, crtCodeLookup);
            crtCodeLookup.CodeValueFormat = "STRING";

            await DbSet.AddAsync(crtCodeLookup);

            return crtCodeLookup;
        }

        public async Task<CodeLookupDto> GetCodeLookupByIdAsync(decimal codeLookupId)
        {
            var codeLookup = await DbSet.AsNoTracking()
                .FirstOrDefaultAsync(x => x.CodeLookupId == codeLookupId);

            return Mapper.Map<CodeLookupDto>(codeLookup);
        }

        public async Task UpdateCodeLookupAsync(CodeLookupUpdateDto codeLookup)
        {
            var crtCodeLookup = await DbSet.FirstAsync(x => x.CodeLookupId == codeLookup.CodeLookupId);

            crtCodeLookup.EndDate = codeLookup.EndDate?.Date;

            Mapper.Map(codeLookup, crtCodeLookup);
        }
    }
}