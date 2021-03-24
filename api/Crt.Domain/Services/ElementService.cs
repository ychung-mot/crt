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
        Task<ElementDto> GetElementByIdAsync(decimal elementId);
        Task<(decimal elementId, Dictionary<string, List<string>> errors)> CreateElementAsync(ElementCreateDto element);
        Task<(bool notFound, Dictionary<string, List<string>> errors)> UpdateElementAsync(ElementUpdateDto element);
        Task<(bool notFound, Dictionary<string, List<string>> errors)> DeleteElementAsync(decimal elementId);
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

        public async Task<ElementDto> GetElementByIdAsync(decimal elementId)
        {
            return await _elementRepo.GetElementByIdAsync(elementId);
        }

        public async Task<(decimal elementId, Dictionary<string, List<string>> errors)> CreateElementAsync(ElementCreateDto element)
        {
            element.TrimStringFields();

            var errors = new Dictionary<string, List<string>>();
            errors = _validator.Validate(Entities.Element, element, errors);

            await ValidateElement(element, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtElement = await _elementRepo.CreateElementAsync(element);

            _unitOfWork.Commit();

            return (crtElement.ElementId, errors);
        }

        public async Task<(bool notFound, Dictionary<string, List<string>> errors)> UpdateElementAsync(ElementUpdateDto element)
        {
            element.TrimStringFields();

            var crtElement = await _elementRepo.GetElementByIdAsync(element.ElementId);

            if (crtElement == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            errors = _validator.Validate(Entities.Element, element, errors);

            await ValidateElement(element, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _elementRepo.UpdateElementAsync(element);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<(bool notFound, Dictionary<string, List<string>> errors)> DeleteElementAsync(decimal elementId)
        {
            var crtElement = await _elementRepo.GetElementByIdAsync(elementId);

            if (crtElement == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            if (await _elementRepo.IsElementInUseAsync(elementId))
            {
                errors.AddItem(Fields.Code, $"Element ID: [{elementId}], Code: [{crtElement.Code}] is in use and cannot be deleted.");
            }

            await _elementRepo.DeleteElementAsync(elementId);

            _unitOfWork.Commit();

            return (false, errors);
        }

        private async Task ValidateElement(ElementSaveDto element, Dictionary<string, List<string>> errors)
        {
            var elementId = element.GetType() == typeof(ElementUpdateDto) ? ((ElementUpdateDto)element).ElementId : 0M;

            if (await _elementRepo.DoesCodeExistAsync(elementId, element.Code))
            {
                errors.AddItem(Fields.Code, $"Code [{element.Code}] already exists");
            }
        }
    }
}
