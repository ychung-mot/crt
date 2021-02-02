using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IUserRoleRepository : ICrtRepositoryBase<CrtUserRole>
    {
        Task<bool> IsRoleInUseAsync(decimal roleId);
    }

    public class UserRoleRepository : CrtRepositoryBase<CrtUserRole>, IUserRoleRepository
    {
        public UserRoleRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<bool> IsRoleInUseAsync(decimal roleId)
        {
            return await DbSet.AnyAsync(x => x.RoleId == roleId);
        }
    }
}
