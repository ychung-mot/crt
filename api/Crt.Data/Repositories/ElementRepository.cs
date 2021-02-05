using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.Element;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IElementRepository
    {
        Task<IEnumerable<ElementDto>> GetElementsAsync();
    }

    public class ElementRepository : CrtRepositoryBase<CrtElement>, IElementRepository
    {
        public ElementRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<IEnumerable<ElementDto>> GetElementsAsync()
        {
            return await GetAllNoTrackAsync<ElementDto>(x => x.EndDate == null || x.EndDate > DateTime.Today);
        }
    }
}
