using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos.QtyAccmp;
using Crt.Model.Utils;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IQtyAccmpService
    {
        Task<QtyAccmpDto> GetQtyAccmpByIdAsync(decimal qtyAccmpId);
        Task<(decimal qtyAccmpId, Dictionary<string, List<string>> errors)> CreateQtyAccmpAsync(QtyAccmpCreateDto qtyAccmp);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateQtyAccmpAsync(QtyAccmpUpdateDto qtyAccmp);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteQtyAccmpAsync(decimal projectId, decimal qtyAccmpId);
    }

    public class QtyAccmpService : CrtServiceBase, IQtyAccmpService
    {
        private IQtyAccmpRepository _qtyAccmpRepo;
        private IUserRepository _userRepo;

        public QtyAccmpService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork,
             IQtyAccmpRepository qtyAccmpRepo, IUserRepository userRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _qtyAccmpRepo = qtyAccmpRepo;
            _userRepo = userRepo;
        }

        public async Task<QtyAccmpDto> GetQtyAccmpByIdAsync(decimal qtyAccmpId)
        {
            return await _qtyAccmpRepo.GetQtyAccmpByIdAsync(qtyAccmpId);
        }

        public async Task<(decimal qtyAccmpId, Dictionary<string, List<string>> errors)> CreateQtyAccmpAsync(QtyAccmpCreateDto qtyAccmp)
        {
            qtyAccmp.TrimStringFields();

            var errors = new Dictionary<string, List<string>>();

            var entity = GetValidationEntity(qtyAccmp);

            if (entity == null)
            {
                errors.AddItem(Fields.QtyAccmpLkupId, $"QtyAccmp lookup ID [{qtyAccmp.QtyAccmpLkupId}] is not valid");
                return (0, errors);
            }

            _validator.Validate(entity, qtyAccmp, errors);

            await ValidateQtyAccmp(qtyAccmp, errors);

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var crtQtyAccmp = await _qtyAccmpRepo.CreateQtyAccmpAsync(qtyAccmp);

            _unitOfWork.Commit();

            return (crtQtyAccmp.QtyAccmpId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateQtyAccmpAsync(QtyAccmpUpdateDto qtyAccmp)
        {
            qtyAccmp.TrimStringFields();

            var crtQtyAccmp = await _qtyAccmpRepo.GetQtyAccmpByIdAsync(qtyAccmp.QtyAccmpId);

            if (crtQtyAccmp == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            var entity = GetValidationEntity(qtyAccmp);

            if (entity == null)
            {
                errors.AddItem(Fields.QtyAccmpLkupId, $"QtyAccmp lookup ID [{qtyAccmp.QtyAccmpLkupId}] is not valid");
                return (false, errors);
            }

            _validator.Validate(entity, qtyAccmp, errors);

            await ValidateQtyAccmp(qtyAccmp, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _qtyAccmpRepo.UpdateQtyAccmpAsync(qtyAccmp);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteQtyAccmpAsync(decimal projectId, decimal qtyAccmpId)
        {
            var crtQtyAccmp = await _qtyAccmpRepo.GetQtyAccmpByIdAsync(qtyAccmpId);

            if (crtQtyAccmp == null || crtQtyAccmp.ProjectId != projectId)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            await _qtyAccmpRepo.DeleteQtyAccmpAsync(qtyAccmpId);

            _unitOfWork.Commit();

            return (false, errors);
        }

        private async Task ValidateQtyAccmp(QtyAccmpSaveDto qtyAccmp, Dictionary<string, List<string>> errors)
        {
            await Task.CompletedTask;
        }

        private string GetValidationEntity(QtyAccmpSaveDto qtyAccmp)
        {
            var qtyAccmpLkup = _validator.CodeLookup.FirstOrDefault(x => x.CodeLookupId == qtyAccmp.QtyAccmpLkupId);

            if (qtyAccmpLkup == null || (qtyAccmpLkup.CodeSet != CodeSet.Quantity && qtyAccmpLkup.CodeSet != CodeSet.Accomplishment))
            {
                return null;
            }

            return qtyAccmpLkup.CodeSet == CodeSet.Quantity ? Entities.Qty : Entities.Accmp;
        }
    }
}
