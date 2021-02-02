using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
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
        IEnumerable<CodeLookupDto> GetCodeLookups();
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
    }
}