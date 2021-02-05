using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos.Element;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IElementService
    {
        Task<IEnumerable<ElementDto>> GetElementsAsync();
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
    }
}
