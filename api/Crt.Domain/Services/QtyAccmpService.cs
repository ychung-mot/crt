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
    public interface IQtyAccmpService
    {
        
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
    }
}
