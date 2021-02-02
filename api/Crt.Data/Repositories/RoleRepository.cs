using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Permission;
using Crt.Model.Dtos.Role;
using Crt.Model.Dtos.RolePermission;
using Crt.Model.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IRoleRepository : ICrtRepositoryBase<CrtRole>
    {
        Task<int> CountActiveRoleIdsAsync(IEnumerable<decimal> roles);
        Task<PagedDto<RoleSearchDto>> GetRolesAync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
        Task<RoleDto> GetRoleAsync(decimal roleId);
        Task<PermissionsInRoleDto> GetRolePermissionsAsync(decimal roleId);
        Task<CrtRole> CreateRoleAsync(RoleCreateDto role);
        Task UpdateRoleAsync(RoleUpdateDto role);
        Task DeleteRoleAsync(RoleDeleteDto role);
        Task<bool> DoesNameExistAsync(string name);
    }
    public class RoleRepository : CrtRepositoryBase<CrtRole>, IRoleRepository
    {
        private IUserRoleRepository _userRoleRepo;

        public RoleRepository(AppDbContext dbContext, IMapper mapper, IUserRoleRepository userRoleRepo, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
            _userRoleRepo = userRoleRepo;
        }

        public async Task<int> CountActiveRoleIdsAsync(IEnumerable<decimal> roles)
        {
            return await DbSet.CountAsync(r => roles.Contains(r.RoleId) && (r.EndDate == null || r.EndDate > DateTime.Today));
        }

        public async Task<PagedDto<RoleSearchDto>> GetRolesAync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            var query = DbSet.AsNoTracking();

            if (searchText.IsNotEmpty())
            {
                searchText = searchText.Trim();

                query = query
                    .Where(x => x.Name.Contains(searchText) || x.Description.Contains(searchText));
            }

            if (isActive != null)
            {
                query = (bool)isActive
                    ? query.Where(x => x.EndDate == null || x.EndDate > DateTime.Today)
                    : query.Where(x => x.EndDate != null && x.EndDate <= DateTime.Today);
            }

            var pagedEntity = await Page<CrtRole, CrtRole>(query, pageSize, pageNumber, orderBy, direction);

            var roles = Mapper.Map<IEnumerable<RoleSearchDto>>(pagedEntity.SourceList);

            // Find out which roles are in use
            await foreach (var roleId in FindRolesInUseAync(roles.Select(x => x.RoleId)))
            {
                roles.FirstOrDefault(x => x.RoleId == roleId).IsReferenced = true;
            }

            var pagedDTO = new PagedDto<RoleSearchDto>
            {
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = pagedEntity.TotalCount,
                SourceList = roles,
                OrderBy = orderBy,
                Direction = direction
            };

            return pagedDTO;
        }

        public async Task<PermissionsInRoleDto> GetRolePermissionsAsync(decimal roleId)
        {
            var role = await DbSet.AsNoTracking()
                .Include(x => x.CrtRolePermissions)
                    .ThenInclude(x => x.Permission)
                .FirstAsync(x => x.RoleId == roleId);

            return new PermissionsInRoleDto
            {
                RoleName = role.Name,
                Permissions = role.CrtRolePermissions
                    .Where(x => x.EndDate == null || x.EndDate > DateTime.Today)
                    .Select(x => x.Permission.Name).ToArray()
            };
        }

        public async Task<RoleDto> GetRoleAsync(decimal roleId)
        {
            var roleEntity = await DbSet.AsNoTracking()
                    .Include(x => x.CrtRolePermissions)
                    .Include(x => x.CrtUserRoles)
                    .FirstOrDefaultAsync(x => x.RoleId == roleId);

            if (roleEntity == null)
                return null;

            var role = Mapper.Map<RoleDto>(roleEntity);

            var permissionIds =
                roleEntity
                .CrtRolePermissions
                .Where(x => x.EndDate == null || x.EndDate > DateTime.Today)
                .Select(x => x.PermissionId)
                .ToList();

            role.Permissions = permissionIds;

            role.IsReferenced = await _userRoleRepo.IsRoleInUseAsync(role.RoleId);

            return role;
        }

        public async Task<CrtRole> CreateRoleAsync(RoleCreateDto role)
        {
            var roleEntity = await AddAsync(role);

            foreach (var permission in role.Permissions)
            {
                roleEntity.CrtRolePermissions
                    .Add(new CrtRolePermission
                    {
                        PermissionId = permission
                    });
            }

            return roleEntity;
        }

        public async Task UpdateRoleAsync(RoleUpdateDto role)
        {
            //remove time portion
            role.EndDate = role.EndDate?.Date;

            var roleEntity = await DbSet
                    .Include(x => x.CrtRolePermissions)
                    .FirstAsync(x => x.RoleId == role.RoleId);

            Mapper.Map(role, roleEntity);

            SyncPermissions(role, roleEntity);
        }

        private void SyncPermissions(RoleUpdateDto role, CrtRole roleEntity)
        {
            var permissionsToDelete =
                roleEntity.CrtRolePermissions.Where(x => !role.Permissions.Contains(x.PermissionId)).ToList();

            for (var i = permissionsToDelete.Count() - 1; i >= 0; i--)
            {
                DbContext.Remove(permissionsToDelete[i]);
            }

            var existingPermissionIds = roleEntity.CrtRolePermissions.Select(x => x.PermissionId);

            var newPermissionIds = role.Permissions.Where(x => !existingPermissionIds.Contains(x));

            foreach (var permissionId in newPermissionIds)
            {
                roleEntity.CrtRolePermissions
                    .Add(new CrtRolePermission
                    {
                        PermissionId = permissionId,
                        RoleId = roleEntity.RoleId
                    });
            }
        }

        public async Task DeleteRoleAsync(RoleDeleteDto role)
        {
            //remove time portion
            role.EndDate = role.EndDate?.Date;

            var roleEntity = await DbSet
                .FirstAsync(x => x.RoleId == role.RoleId);

            Mapper.Map(role, roleEntity);
        }

        public async Task<bool> DoesNameExistAsync(string name)
        {
            return await DbSet.AnyAsync(x => x.Name == name);
        }

        private async IAsyncEnumerable<decimal> FindRolesInUseAync(IEnumerable<decimal> roleIds)
        {
            foreach (var roleId in roleIds)
            {
                if (await _userRoleRepo.IsRoleInUseAsync(roleId))
                    yield return roleId;
            }
        }
    }
}
