using Crt.Data.Database;
using Crt.Model;

namespace Crt.Domain.Services.Base
{
    public class CrtServiceBase
    {
        protected CrtCurrentUser _currentUser;
        protected IFieldValidatorService _validator;
        protected IUnitOfWork _unitOfWork;

        public CrtServiceBase(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork)
        {
            _currentUser = currentUser;
            _validator = validator;
            _unitOfWork = unitOfWork;
        }
    }
}
