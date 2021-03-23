using AutoMapper;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories.Base;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Region;
using Crt.Model.Dtos.User;
using Crt.Model.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Data.Repositories
{
    public interface IUserRepository : ICrtRepositoryBase<CrtSystemUser>
    {
        Task<UserCurrentDto> GetCurrentUserAsync();
        Task<PagedDto<UserSearchDto>> GetUsersAsync(decimal[]? regionIds, string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
        Task<UserDto> GetUserAsync(decimal systemUserId);
        Task<CrtSystemUser> CreateUserAsync(UserCreateDto user, AdAccount account);
        Task<bool> DoesUsernameExistAsync(string username);
        Task UpdateUserAsync(UserUpdateDto userDto);
        Task DeleteUserAsync(UserDeleteDto user);
        Task<CrtSystemUser> GetActiveUserEntityAsync(Guid userGuid);
        Task<int> UpdateUserFromAdAsync(AdAccount user, long concurrencyControlNumber);
        Task UpdateUserApiClientId(string clientId);
    }

    public class UserRepository : CrtRepositoryBase<CrtSystemUser>, IUserRepository
    {
        public UserRepository(AppDbContext dbContext, IMapper mapper, CrtCurrentUser currentUser)
            : base(dbContext, mapper, currentUser)
        {
        }

        public async Task<UserCurrentDto> GetCurrentUserAsync()
        {
            var userEntity = await DbSet.AsNoTracking()
                                .Include(x => x.CrtUserRoles)
                                    .ThenInclude(x => x.Role)
                                        .ThenInclude(x => x.CrtRolePermissions)
                                            .ThenInclude(x => x.Permission)
                                .Include(x => x.CrtRegionUsers)
                                    .ThenInclude(x => x.Region)
                                        .ThenInclude(x => x.CrtRegionDistricts)
                                .FirstAsync(u => u.UserGuid == _currentUser.UserGuid);

            var currentUser = Mapper.Map<UserCurrentDto>(userEntity);

            var permissions =
                userEntity
                .CrtUserRoles
                .Select(r => r.Role)
                .Where(r => r.EndDate == null || r.EndDate > DateTime.Today) //active roles
                .SelectMany(r => r.CrtRolePermissions.Select(rp => rp.Permission))
                .Where(p => p.EndDate == null || p.EndDate > DateTime.Today) //active permissions
                .ToLookup(p => p.Name)
                .Select(p => p.First())
                .Select(p => p.Name)
                .ToList();

            currentUser.Permissions = permissions;

            var regions =
                userEntity
                .CrtRegionUsers
                .Select(s => s.Region);

            currentUser.Regions = new List<RegionDto>(Mapper.Map<IEnumerable<RegionDto>>(regions));
            currentUser.RegionIds = currentUser.Regions.Select(x => x.RegionId).ToArray();

            currentUser.IsSystemAdmin = userEntity.CrtUserRoles.Any(x => x.Role.Name == Constants.SystemAdmin);

            return currentUser;
        }

        public async Task<CrtSystemUser> GetActiveUserEntityAsync(Guid userGuid)
        {
            return await DbSet.FirstOrDefaultAsync(u => u.UserGuid == userGuid && (u.EndDate == null || u.EndDate > DateTime.Today));
        }

        /// <summary>
        /// This method can be called concurrently by a typical client which asynchronously calls APIs
        /// In order to avoid unecessary multiple updates and the concurrency control number exception,
        /// it runs SQL with optimistic concurrency control.
        /// </summary>
        /// <param name="user"></param>
        /// <param name="concurrencyControlNumber"></param>
        /// <returns></returns>
        public async Task<int> UpdateUserFromAdAsync(AdAccount user, long concurrencyControlNumber)
        {
            var sql = new StringBuilder("UPDATE CRT_SYSTEM_USER SET ");
            sql.Append("USERNAME = {0}, ");
            sql.Append("FIRST_NAME = {1}, ");
            sql.Append("LAST_NAME = {2}, ");
            sql.Append("EMAIL = {3}, ");
            sql.Append("CONCURRENCY_CONTROL_NUMBER = CONCURRENCY_CONTROL_NUMBER + 1 ");
            sql.Append("WHERE USER_GUID = {4} AND CONCURRENCY_CONTROL_NUMBER = {5} ");

            return await DbContext.Database.ExecuteSqlRawAsync(sql.ToString(), user.Username, user.FirstName, user.LastName, user.Email, user.UserGuid, concurrencyControlNumber);
        }

        public async Task<PagedDto<UserSearchDto>> GetUsersAsync(decimal[]? regionIds, string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            var query = DbSet.AsNoTracking();

            if (regionIds != null && regionIds.Length > 0)
            {
                query = query.Where(u => u.CrtRegionUsers.Any(s => regionIds.Contains(s.RegionId)));
            }

            if (searchText.IsNotEmpty())
            {
                searchText = searchText.Trim();

                query = query
                    .Where(u => u.Username.Contains(searchText) || u.FirstName.Contains(searchText) || (u.FirstName + " " + u.LastName).Contains(searchText) || u.LastName.Contains(searchText) || u.Email.Contains(searchText));
            }

            if (isActive != null)
            {
                query = (bool)isActive
                    ? query.Where(u => u.EndDate == null || u.EndDate > DateTime.Today)
                    : query.Where(u => u.EndDate != null && u.EndDate <= DateTime.Today);
            }

            query = query.Include(u => u.CrtRegionUsers)
                        .ThenInclude(u => u.Region);

            var pagedEntity = await Page<CrtSystemUser, CrtSystemUser>(query, pageSize, pageNumber, orderBy, direction);

            var users = Mapper.Map<IEnumerable<UserSearchDto>>(pagedEntity.SourceList);
            var userRegions = pagedEntity.SourceList.SelectMany(u => u.CrtRegionUsers).ToLookup(u => u.SystemUserId);

            foreach (var user in users)
            {
                user.RegionNumbers = string.Join(",", userRegions[user.SystemUserId].Select(x => x.Region?.RegionNumber).OrderBy(x => x));
                user.HasLogInHistory = pagedEntity.SourceList.Any(u => u.SystemUserId == user.SystemUserId && u.UserGuid != null);
            }

            var pagedDTO = new PagedDto<UserSearchDto>
            {
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = pagedEntity.TotalCount,
                SourceList = users,
                OrderBy = orderBy,
                Direction = direction
            };

            return pagedDTO;
        }

        public async Task<UserDto> GetUserAsync(decimal systemUserId)
        {
            var userEntity = await DbSet.AsNoTracking()
                    .Include(x => x.CrtUserRoles)
                    .Include(x => x.CrtRegionUsers)
                    .FirstOrDefaultAsync(u => u.SystemUserId == systemUserId);

            if (userEntity == null)
                return null;

            var user = Mapper.Map<UserDto>(userEntity);

            var roleIds =
                userEntity
                .CrtUserRoles
                .Where(r => r.EndDate == null || r.EndDate > DateTime.Today) //active roles
                .Select(r => r.RoleId)
                .ToList();

            user.UserRoleIds = roleIds;

            var userRegions = userEntity.CrtRegionUsers.Select(r => r.RegionId).ToList();
            user.UserRegionIds = userRegions;
            
            return user;
        }

        public async Task<bool> DoesUsernameExistAsync(string username)
        {
            return await DbSet.AnyAsync(u => u.Username == username);
        }

        public async Task<CrtSystemUser> CreateUserAsync(UserCreateDto user, AdAccount account)
        {
            var userEntity = new CrtSystemUser
            {
                Username = account.Username.ToUpperInvariant(),
                UserGuid = account.UserGuid,
                FirstName = account.FirstName,
                LastName = account.LastName,
                Email = account.Email,
                EndDate = user.EndDate,
            };

            foreach (var regionId in user.UserRegionIds)
            {
                userEntity.CrtRegionUsers
                    .Add(new CrtRegionUser
                    {
                        RegionId = regionId
                    });
            }

            foreach (var roleId in user.UserRoleIds)
            {
                userEntity.CrtUserRoles
                    .Add(new CrtUserRole
                    {
                        RoleId = roleId
                    }); ;
            }

            await DbSet.AddAsync(userEntity);

            return userEntity;
        }

        public async Task UpdateUserAsync(UserUpdateDto userDto)
        {
            //remove time portion
            userDto.EndDate = userDto.EndDate?.Date;

            var userEntity = await DbSet
                    .Include(x => x.CrtUserRoles)
                    .Include(x => x.CrtRegionUsers)
                    .FirstAsync(u => u.SystemUserId == userDto.SystemUserId);

            Mapper.Map(userDto, userEntity);

            SyncRoles(userDto, userEntity);

            SyncRegions(userDto, userEntity);

        }

        private void SyncRoles(UserUpdateDto userDto, CrtSystemUser userEntity)
        {
            var rolesToDelete =
                userEntity.CrtUserRoles.Where(r => !userDto.UserRoleIds.Contains(r.RoleId)).ToList();

            for (var i = rolesToDelete.Count() - 1; i >= 0; i--)
            {
                DbContext.Remove(rolesToDelete[i]);
            }

            var existingRoleIds = userEntity.CrtUserRoles.Select(r => r.RoleId);

            var newRoleIds = userDto.UserRoleIds.Where(r => !existingRoleIds.Contains(r));

            foreach (var roleId in newRoleIds)
            {
                userEntity.CrtUserRoles
                    .Add(new CrtUserRole
                    {
                        RoleId = roleId,
                        SystemUserId = userEntity.SystemUserId
                    });
            }
        }

        private void SyncRegions(UserUpdateDto userDto, CrtSystemUser userEntity)
        {
            var regionsToDelete =
                userEntity.CrtRegionUsers.Where(s => !userDto.UserRegionIds.Contains(s.RegionId)).ToList();

            for (var i = regionsToDelete.Count() - 1; i >= 0; i--)
            {
                DbContext.Remove(regionsToDelete[i]);
            }

            var existingRegions = userEntity.CrtRegionUsers.Select(s => s.RegionId);

            var newRegionIds = userDto.UserRegionIds.Where(r => !existingRegions.Contains(r));

            foreach (var regionId in newRegionIds)
            {
                userEntity.CrtRegionUsers
                    .Add(new CrtRegionUser
                    {
                        RegionId = regionId,
                        SystemUserId = userEntity.SystemUserId
                    });
            }
        }

        public async Task DeleteUserAsync(UserDeleteDto user)
        {
            //remove time portion
            user.EndDate = user.EndDate?.Date;

            var userEntity = await DbSet
                .FirstAsync(u => u.SystemUserId == user.SystemUserId);

            Mapper.Map(user, userEntity);
        }

        public async Task UpdateUserApiClientId(string apiClientId)
        {
            var userEntity = await DbSet.FirstAsync(u => u.UserGuid == _currentUser.UserGuid);

            userEntity.ApiClientId = apiClientId;
        }

        /* No longer required in users, moved to code lookup
         * public async Task<IEnumerable<UserManagerDto>> GetManagersAsync()
        {
            return await GetAllNoTrackAsync<UserManagerDto>(u => u.IsProjectMgr == true && (u.EndDate == null || u.EndDate > DateTime.Today));
        }*/
    }
}
