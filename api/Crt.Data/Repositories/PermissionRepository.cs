using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos.Permission;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IPermissionRepository : ICrtRepositoryBase<CrtPermission>
    {
        Task<IEnumerable<PermissionDto>> GetActivePermissionsAsync();
        Task<int> CountActivePermissionIdsAsnyc(IEnumerable<decimal> permissions);
    }
    public class PermissionRepository : CrtRepositoryBase<CrtPermission>, IPermissionRepository
    {
        public PermissionRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }
        public async Task<int> CountActivePermissionIdsAsnyc(IEnumerable<decimal> permissions)
        {
            return await DbSet.CountAsync(x => permissions.Contains(x.PermissionId) && (x.EndDate == null || x.EndDate > DateTime.Today));
        }
        public async Task<IEnumerable<PermissionDto>> GetActivePermissionsAsync()
        {
            var permissionEntity = await DbSet.AsNoTracking()
                .Where(x => x.EndDate == null || x.EndDate > DateTime.Today)
                .ToListAsync();

            return Mapper.Map<IEnumerable<PermissionDto>>(permissionEntity);
        }

    }
}
