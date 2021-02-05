using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Project;
using Crt.Model.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IFinTargetService
    {
        
    }

    public class FinTargetService : CrtServiceBase, IFinTargetService
    {
        private IFinTargetRepository _finTargetRepo;
        private IUserRepository _userRepo;

        public FinTargetService(CrtCurrentUser currentUser, IFieldValidatorService validator, IUnitOfWork unitOfWork,
             IFinTargetRepository finTargetRepo, IUserRepository userRepo)
            : base(currentUser, validator, unitOfWork)
        {
            _finTargetRepo = finTargetRepo;
            _userRepo = userRepo;
        }
    }
}
