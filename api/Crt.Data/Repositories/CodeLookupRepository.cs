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
        Task<bool> DoesCodeLookupExistAsync(decimal id, string codeName, string codeSet);
        Task<bool> IsCodeLookupInUseAsync(decimal id);
        Task DeleteCodeLookupAsync(decimal id);
        Task UpdateCodeLookupDisplayOrder(string codeSet);
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

            foreach (var result in results.SourceList)
            {
                result.IsReferenced = await IsCodeLookupInUseAsync(result.CodeLookupId);
                result.canDelete = !result.IsReferenced;
            }

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

            codeLookup.EndDate = codeLookup.EndDate?.Date;

            Mapper.Map(codeLookup, crtCodeLookup);
        }

        public async Task DeleteCodeLookupAsync(decimal id)
        {
            var codeLookup = await DbSet.FirstAsync(x => x.CodeLookupId == id);

            DbSet.Remove(codeLookup);
        }

        public async Task<bool> DoesCodeLookupExistAsync(decimal id, string codeName, string codeSet)
        {
            var codes = await DbSet.AsNoTracking()
                .Where(x => x.CodeSet == codeSet && x.CodeName == codeName)
                .Select(x => new { x.CodeLookupId })
                .ToListAsync();

            return codes.Any(x => x.CodeLookupId != id);
        }

        public async Task<bool> IsCodeLookupInUseAsync(decimal id)
        {
            var inFinTarget = await DbContext.CrtFinTargets.AsNoTracking()
                .AnyAsync(x => x.FiscalYearLkupId == id || x.FundingTypeLkupId == id);
            var inProject = await DbContext.CrtProjects.AsNoTracking()
                .AnyAsync(x => x.NearstTwnLkupId == id || x.RegionId == id
                || x.CapIndxLkupId == id || x.RcLkupId == id || x.ProjectMgrLkupId == id );
            var inQtyAccmp = await DbContext.CrtQtyAccmps.AsNoTracking()
                .AnyAsync(x => x.FiscalYearLkupId == id || x.QtyAccmpLkupId == id);
            var inRatio = await DbContext.CrtRatios.AsNoTracking()
                .AnyAsync(x => x.RatioRecordLkupId == id);
            var inTender = await DbContext.CrtTenders.AsNoTracking()
                .AnyAsync(x => x.WinningCntrctrLkupId == id);
            var inElement = await DbContext.CrtElements.AsNoTracking()
                .AnyAsync(x => x.ProgramCategoryLkupId == id || x.ProgramLkupId == id || x.ServiceLineLkupId == id);

            return (inFinTarget || inProject || inQtyAccmp || inRatio || inTender || inElement);
        }

        public async Task UpdateCodeLookupDisplayOrder(string codeSet)
        {
            var crtCodeLookups = await DbSet
                .Where(x => x.CodeSet == codeSet)
                .OrderBy(x => x.DisplayOrder)
                .ToListAsync();

            var newDisplayOrder = 10;

            foreach (var lookup in crtCodeLookups)
            {
                lookup.DisplayOrder = newDisplayOrder;
                newDisplayOrder += 10;
            }
        }
    }
}