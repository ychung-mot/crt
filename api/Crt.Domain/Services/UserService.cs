using AutoMapper;
using Crt.Data.Database;
using Crt.Data.Database.Entities;
using Crt.Data.Repositories;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.User;
using Crt.Model.Utils;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Novell.Directory.Ldap;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Security;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IUserService
    {
        Task<UserCurrentDto> GetCurrentUserAsync();
        Task<PagedDto<UserSearchDto>> GetUsersAsync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
        Task<UserDto> GetUserAsync(decimal systemUserId);
        Task<AdAccountDto> GetAdAccountAsync(string username);
        Task<(decimal SystemUserId, Dictionary<string, List<string>> Errors)> CreateUserAsync(UserCreateDto user);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateUserAsync(UserUpdateDto user);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteUserAsync(UserDeleteDto user);
        Task<CrtSystemUser> GetActiveUserEntityAsync(Guid userGuid);
        Task<int> UpdateUserFromAdAsync(string username, long concurrencyControlNumber);
    }
    public class UserService : IUserService
    {
        private IUserRepository _userRepo;
        private IRoleRepository _roleRepo;
        private IUnitOfWork _unitOfWork;
        private CrtCurrentUser _currentUser;
        private IFieldValidatorService _validator;
        private IMapper _mapper;
        private ILogger _logger;
        private IConfiguration _config;

        private string _userId;
        private string _password;
        private string _server;
        private int _port;

        public UserService(IUserRepository userRepo, IRoleRepository roleRepo,
            IUnitOfWork unitOfWork, CrtCurrentUser currentUser, IFieldValidatorService validator, IMapper mapper, 
            IConfiguration config,
            ILogger<UserService> logger)
        {
            _userRepo = userRepo;
            _roleRepo = roleRepo;
            _unitOfWork = unitOfWork;
            _currentUser = currentUser;
            _validator = validator;
            _mapper = mapper;
            _logger = logger;
            _config = config;

            _userId = config.GetValue<string>("ServiceAccount:User");
            _password = config.GetValue<string>("ServiceAccount:Password");
            _server = config.GetValue<string>("ServiceAccount:Server");
            _port = config.GetValue<int>("ServiceAccount:Port");

        }

        public async Task<UserCurrentDto> GetCurrentUserAsync()
        {
            return await _userRepo.GetCurrentUserAsync();
        }

        public async Task<CrtSystemUser> GetActiveUserEntityAsync(Guid userGuid)
        {
            return await _userRepo.GetActiveUserEntityAsync(userGuid);
        }

        public async Task<PagedDto<UserSearchDto>> GetUsersAsync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            return await _userRepo.GetUsersAsync(searchText, isActive, pageSize, pageNumber, orderBy, direction);
        }

        public async Task<UserDto> GetUserAsync(decimal systemUserId)
        {
            return await _userRepo.GetUserAsync(systemUserId);
        }

        public async Task<AdAccountDto> GetAdAccountAsync(string username)
        {
            var account = await LdapSearch(LdapAttrs.SamAccountName, username);

            if (account != null)
            {
                return _mapper.Map<AdAccountDto>(account);
            }

            return null;
        }

        public async Task<(decimal SystemUserId, Dictionary<string, List<string>> Errors)> CreateUserAsync(UserCreateDto user)
        {
            var account = await LdapSearch(LdapAttrs.SamAccountName, user.Username);

            if (account == null)
            {
                throw new CrtException($"Unable to retrieve User[{user.Username}] from LDAP Service.");
            }

            user.Email = account.Email;

            var errors = await ValidateUserDtoAsync(user);

            if (await _userRepo.DoesUsernameExistAsync(user.Username))
            {
                errors.AddItem(Fields.Username, $"Username [{user.Username}] already exists.");
            }

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var userEntity = await _userRepo.CreateUserAsync(user, account);
            _unitOfWork.Commit();

            return (userEntity.SystemUserId, errors);
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateUserAsync(UserUpdateDto user)
        {
            var userFromDb = await GetUserAsync(user.SystemUserId);

            if (userFromDb == null)
            {
                return (true, null);
            }

            var errors = await ValidateUserDtoAsync(user);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _userRepo.UpdateUserAsync(user);
            _unitOfWork.Commit();

            return (false, errors);
        }

        private async Task<Dictionary<string, List<string>>> ValidateUserDtoAsync<T>(T user) where T : IUserSaveDto
        {
            var entityName = Entities.User;
            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(entityName, user, errors);

            var roleCount = await _roleRepo.CountActiveRoleIdsAsync(user.UserRoleIds);
            if (roleCount != user.UserRoleIds.Count)
            {
                errors.AddItem(Fields.RoleId, $"Some of the user's role IDs are invalid or inactive.");
            }

            if (!_currentUser.UserInfo.IsSystemAdmin)
            {
                foreach (var roleId in user.UserRoleIds)
                {
                    await CheckIfCurrentUserHasAllThePermissions(roleId, errors);
                }
            }

            return errors;
        }

        private async Task CheckIfCurrentUserHasAllThePermissions(decimal roleId, Dictionary<string, List<string>> errors)
        {
            var permissionsInRole = await _roleRepo.GetRolePermissionsAsync(roleId);

            foreach (var permission in permissionsInRole.Permissions)
            {
                if (!_currentUser.UserInfo.Permissions.Any(x => x == permission))
                {
                    var role = await _roleRepo.GetRoleAsync(roleId);
                    errors.AddItem(Fields.RoleId, $"User is not authorized to assign the role {permissionsInRole.RoleName}");
                    return;
                }
            }
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteUserAsync(UserDeleteDto user)
        {
            //todo: if user has no log-in history, we can delete user instead of deactivating it. 
            var userFromDb = await GetUserAsync(user.SystemUserId);

            if (userFromDb == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(Entities.User, user, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _userRepo.DeleteUserAsync(user);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<int> UpdateUserFromAdAsync(string username, long concurrencyControlNumber)
        {
            var account = await LdapSearch(LdapAttrs.SamAccountName, username);

            if (account != null)
            {
                return await _userRepo.UpdateUserFromAdAsync(account, concurrencyControlNumber);
            }

            return 0;
        }

        private async Task<AdAccount> LdapSearch(string filterAttr, string value)
        {
            await Task.CompletedTask;

            using var conn = new LdapConnection() { SecureSocketLayer = false };
            conn.Connect(_server, _port);

            conn.UserDefinedServerCertValidationDelegate += (sender, certificate, chain, sslPolicyErrors) =>
            {
                if (sslPolicyErrors == SslPolicyErrors.None)
                    return true;

                if (chain.ChainElements == null)
                    return false;

                return true;
            };

            conn.StartTls();

            conn.Bind(@$"IDIR\{_userId}", _password);

            var filter = $"(&(objectCategory=person)(objectClass=user)({filterAttr}={value}))";
            var search = conn.Search("OU=BCGOV,DC=idir,DC=BCGOV", LdapConnection.ScopeSub, filter, new string[] { "sAMAccountName", "bcgovGUID", "givenName", "sn", "mail", "displayName" }, false);

            var entry = search.FirstOrDefault();

            if (entry == null)
                return null;

            return new AdAccount
            {
                Username = entry.GetAttribute("sAMAccountName").StringValue,
                UserGuid = new Guid(entry.GetAttribute("bcgovGUID").StringValue),
                FirstName = entry.GetAttribute("givenName").StringValue,
                LastName = entry.GetAttribute("sn").StringValue,
                Email = entry.GetAttributeSet().Any(x => x.Key == "mail") ? entry.GetAttribute("mail").StringValue : "",
                DisplayName = entry.GetAttribute("displayName").StringValue
            };
        }
    }
}
