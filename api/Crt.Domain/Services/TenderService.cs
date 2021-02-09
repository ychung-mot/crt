using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos.Tender;
using Crt.Model.Utils;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface ITenderService
    {
        Task<TenderDto> GetTenderByIdAsync(decimal tenderId);
        Task<(decimal tenderId, Dictionary<string, List<string>> errors)> CreateTenderAsync(TenderCreateDto tender);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateTenderAsync(TenderUpdateDto tender);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteTenderAsync(decimal projectId, decimal tender);
    }

    public class TenderService : CrtServiceBase, ITenderService
    {
        private ITenderRepository _tenderRepo;

        public TenderService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork, ITenderRepository tenderRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _tenderRepo = tenderRepo;
        }

        public async Task<TenderDto> GetTenderByIdAsync(decimal tenderId)
        {
            return await _tenderRepo.GetTenderByIdAsync(tenderId);
        }

        public async Task<(decimal tenderId, Dictionary<string, List<string>> errors)> CreateTenderAsync(TenderCreateDto tender)
        {
            tender.TrimStringFields();

            var errors = new Dictionary<string, List<string>>();

            errors = _validator.Validate(Entities.Tender, tender, errors);

            await ValidateTender(tender, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtTender = await _tenderRepo.CreateTenderAsync(tender);

            _unitOfWork.Commit();

            return (crtTender.TenderId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateTenderAsync(TenderUpdateDto tender)
        {
            tender.TrimStringFields();

            var crtTender = await _tenderRepo.GetTenderByIdAsync(tender.TenderId);

            if (crtTender == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            errors = _validator.Validate(Entities.Tender, tender, errors);

            await ValidateTender(tender, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _tenderRepo.UpdateTenderAsync(tender);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteTenderAsync(decimal projectId, decimal tenderId)
        {
            var crtTender = await _tenderRepo.GetTenderByIdAsync(tenderId);

            if (crtTender == null || crtTender.ProjectId != projectId)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            await _tenderRepo.DeleteTenderAsync(tenderId);

            _unitOfWork.Commit();

            return (false, errors);
        }

        private async Task ValidateTender(TenderSaveDto tender, Dictionary<string, List<string>> errors)
        {
            var tenderId = tender.GetType() == typeof(TenderUpdateDto) ? ((TenderUpdateDto)tender).TenderId : 0M;

            if (await _tenderRepo.TenderNumberAlreadyExists(tender.ProjectId, tenderId, tender.TenderNumber))
            {
                errors.AddItem(Fields.TenderNumber, $"Tender Number [{tender.TenderNumber}] already exists");
            }
        }
    }
}
