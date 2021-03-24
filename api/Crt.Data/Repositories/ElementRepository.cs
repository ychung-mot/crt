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
        Task<ElementDto> GetElementByIdAsync(decimal elementId);
        Task<CrtElement> CreateElementAsync(ElementCreateDto element);
        Task UpdateElementAsync(ElementUpdateDto element);
        Task DeleteElementAsync(decimal elementId);
        Task<bool> IsElementInUseAsync(decimal elementId);
        Task<bool> DoesCodeExistAsync(decimal elementId, string code);
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

            foreach (var result in results.SourceList)
            {
                result.IsReferenced = await IsElementInUseAsync(result.ElementId);
                result.canDelete = !result.IsReferenced;
            }

            return results;
        }

        public async Task<ElementDto> GetElementByIdAsync(decimal elementId)
        {
            var element = await DbSet.AsNoTracking()
                        .Include(x => x.ProgramCategoryLkup)
                        .Include(x => x.ProgramLkup)
                        .Include(x => x.ServiceLineLkup)
                        .FirstOrDefaultAsync(x => x.ElementId == elementId);

            return Mapper.Map<ElementDto>(element);
        }

        public async Task<CrtElement> CreateElementAsync(ElementCreateDto element)
        {
            var crtElement = new CrtElement();

            Mapper.Map(element, crtElement);

            await DbSet.AddAsync(crtElement);

            await UpdateDisplayOrder();

            return crtElement;
        }

        public async Task UpdateElementAsync(ElementUpdateDto element)
        {
            var crtElement = await DbSet
                                .FirstAsync(x => x.ElementId == element.ElementId);

            crtElement.EndDate = element.EndDate?.Date;

            Mapper.Map(element, crtElement);

            await UpdateDisplayOrder();
        }

        public async Task DeleteElementAsync(decimal elementId)
        {
            var crtElement = await DbSet.FirstAsync(x => x.ElementId == elementId);

            DbSet.Remove(crtElement);

            await UpdateDisplayOrder();
        }

        public async Task<bool> DoesCodeExistAsync(decimal elementId, string code)
        {
            var elements = await DbSet.AsNoTracking()
                .Where(x => x.Code == code)
                .Select(x => new { x.ElementId })
                .ToListAsync();

            return elements.Any(x => x.ElementId != elementId);
        }

        public async Task<bool> IsElementInUseAsync(decimal elementId)
        {
            var inFinTarget = await DbContext.CrtFinTargets.AsNoTracking()
                .AnyAsync(x => x.ElementId == elementId);

            return (inFinTarget);
        }

        private async Task UpdateDisplayOrder()
        {
            var crtElements = await DbSet.OrderBy(x => x.DisplayOrder).ToListAsync();

            var newDisplayOrder = 10;

            foreach (var crtElement in crtElements)
            {
                crtElement.DisplayOrder = newDisplayOrder;
                newDisplayOrder += 10;
            }
        }
    }
}
