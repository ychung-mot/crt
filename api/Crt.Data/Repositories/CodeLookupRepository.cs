using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model.Dtos.CodeLookup;
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
        IEnumerable<CodeLookupCache> LoadCodeLookupCache();
    }

    public class CodeLookupRepository : CrtRepositoryBase<CrtCodeLookup>, ICodeLookupRepository
    {
        public CodeLookupRepository(AppDbContext dbContext, IMapper mapper)
            : base(dbContext, mapper)
        {
        }

        public IEnumerable<CodeLookupCache> LoadCodeLookupCache()
        {
            return DbSet.AsNoTracking()
                .Where(x => x.EndDate == null || DateTime.Today < x.EndDate)
                .Select(x =>
                    new CodeLookupCache
                    {
                        CodeSet = x.CodeSet,
                        CodeLookupId = x.CodeLookupId,
                        CodeName = x.CodeName,
                    }
                )
                .ToArray();
        }
    }
}