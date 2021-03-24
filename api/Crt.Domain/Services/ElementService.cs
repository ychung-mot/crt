using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Element;
using Crt.Model.Utils;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IElementService
    {
        Task<IEnumerable<ElementDto>> GetElementsAsync();
        Task<PagedDto<ElementListDto>> SearchElementsAsync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
    }

    public class ElementService : CrtServiceBase, IElementService
    {
        private IElementRepository _elementRepo;

        public ElementService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork, IElementRepository elementRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _elementRepo = elementRepo;
        }

        public async Task<IEnumerable<ElementDto>> GetElementsAsync()
        {
            return await _elementRepo.GetElementsAsync();
        }

        public async Task<PagedDto<ElementListDto>> SearchElementsAsync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            return await _elementRepo.SearchElementsAsync(searchText, isActive, pageSize, pageNumber, orderBy, direction);
        }
    }
}
