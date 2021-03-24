using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Element;
using Crt.Model.Utils;
using Microsoft.EntityFrameworkCore;
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
        Task<PagedDto<ElementListDto>> SearchElementsAsync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
    }

    public class ElementRepository : CrtRepositoryBase<CrtElement>, IElementRepository
    {
        public ElementRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<IEnumerable<ElementDto>> GetElementsAsync()
        {
            return await GetAllNoTrackAsync<ElementDto>(x => x.IsActive == true);
        }

        public async Task<PagedDto<ElementListDto>> SearchElementsAsync(string searchText, bool? isActive, 
            int pageSize, int pageNumber, string orderBy, string direction)
        {
            var query = DbSet.AsNoTracking()
                        .Include(x => x.ProgramCategoryLkup)
                        .Include(x => x.ProgramLkup)
                        .Include(x => x.ServiceLineLkup)
                        .AsQueryable();

            if (isActive != null)
            {
                query = query.Where(x => x.IsActive == isActive);
            }

            if (searchText.IsNotEmpty())
            {
                query = query
                        .Where(x => x.Code.Contains(searchText) || x.Description.Contains(searchText)
                            || x.ProgramCategoryLkup.CodeValueText.Contains(searchText) || x.ProgramCategoryLkup.CodeName.Contains(searchText)
                            || x.ProgramLkup.CodeValueText.Contains(searchText) || x.ProgramLkup.CodeName.Contains(searchText)
                            || x.ServiceLineLkup.CodeValueText.Contains(searchText) || x.ServiceLineLkup.CodeName.Contains(searchText));
            }

            var results = await Page<CrtElement, ElementListDto>(query, pageSize, pageNumber, orderBy, direction);

            return results;
        }
    }
}
