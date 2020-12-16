using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.Role;
using Crt.Model.Utils;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crt.Domain.Services
{
    public interface IRoleService
    {
        Task<int> CountActiveRoleIdsAsync(IEnumerable<decimal> roles);
        Task<PagedDto<RoleSearchDto>> GetRolesAync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction);
        Task<RoleDto> GetRoleAsync(decimal roleId);
        Task<(decimal RoleId, Dictionary<string, List<string>> Errors)> CreateRoleAsync(RoleCreateDto role);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateRoleAsync(RoleUpdateDto role);
        Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteRoleAsync(RoleDeleteDto role);
    }
    public class RoleService : IRoleService
    {
        private IRoleRepository _roleRepo;
        IUserRoleRepository _userRoleRepo;
        private IUnitOfWork _unitOfWork;
        private IFieldValidatorService _validator;
        private IPermissionRepository _permRepo;
        private CrtCurrentUser _currentUser;

        public RoleService(IRoleRepository roleRepo, IUserRoleRepository userRoleRepo, IPermissionRepository permRepo, IUnitOfWork unitOfWork, 
            IFieldValidatorService validator, CrtCurrentUser currentUser)
        {
            _roleRepo = roleRepo;
            _userRoleRepo = userRoleRepo;
            _unitOfWork = unitOfWork;
            _validator = validator;
            _permRepo = permRepo;
            _currentUser = currentUser;
        }

        public async Task<int> CountActiveRoleIdsAsync(IEnumerable<decimal> roles)
        {
            return await _roleRepo.CountActiveRoleIdsAsync(roles);
        }

        public async Task<(decimal RoleId, Dictionary<string, List<string>> Errors)> CreateRoleAsync(RoleCreateDto role)
        {
            var errors = await ValidateRoleDtoAsync(role);

            if (role.Name.IsNotEmpty())
            {
                if (await _roleRepo.DoesNameExistAsync(role.Name))
                {
                    errors.AddItem(Fields.Name, $"Name [{role.Name}] already exists.");
                }
            }

            if (errors.Count > 0)
            {
                return (0, errors);
            }

            var roleEntity = await _roleRepo.CreateRoleAsync(role);

            _unitOfWork.Commit();

            return (roleEntity.RoleId, errors);
        }

        private async Task<Dictionary<string, List<string>>> ValidateRoleDtoAsync<T>(T role) where T : IRoleSaveDto
        {
            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(Entities.Role, role, errors);

            var permissionCount = await _permRepo.CountActivePermissionIdsAsnyc(role.Permissions);
            if (permissionCount != role.Permissions.Count)
            {
                errors.AddItem(Fields.PermissionId, $"Some of the permission IDs are invalid or inactive.");
            }

            return errors;
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> DeleteRoleAsync(RoleDeleteDto role)
        {
            var roleFromDb = await GetRoleAsync(role.RoleId);

            if (roleFromDb == null)
            {
                return (true, null);
            }

            var errors = new Dictionary<string, List<string>>();

            _validator.Validate(Entities.Role, role, errors);

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _roleRepo.DeleteRoleAsync(role);

            _unitOfWork.Commit();

            return (false, errors);
        }

        public async Task<RoleDto> GetRoleAsync(decimal roleId)
        {
            return await _roleRepo.GetRoleAsync(roleId);
        }

        public async Task<PagedDto<RoleSearchDto>> GetRolesAync(string searchText, bool? isActive, int pageSize, int pageNumber, string orderBy, string direction)
        {
            var dto = await _roleRepo.GetRolesAync(searchText, isActive, pageSize, pageNumber, orderBy, direction);

            if (_currentUser.UserInfo.IsSystemAdmin)
                return dto;

            var roles = dto.SourceList.ToList();
            var count = roles.Count() - 1;

            for(var i = count; i >= 0; i--)
            {
                var role = roles[i];
                if (!await CurrentUserHasAllThePermissions(role.RoleId))
                {
                    roles.Remove(role);
                    continue;
                }
            }

            dto.SourceList = roles;
            return dto;
        }

        private async Task<bool> CurrentUserHasAllThePermissions(decimal roleId)
        {
            var permissionsInRole = await _roleRepo.GetRolePermissionsAsync(roleId);

            foreach (var permission in permissionsInRole.Permissions)
            {
                if (!_currentUser.UserInfo.Permissions.Any(x => x == permission))
                    return false;
            }

            return true;
        }

        public async Task<(bool NotFound, Dictionary<string, List<string>> Errors)> UpdateRoleAsync(RoleUpdateDto role)
        {
            var roleFromDb = await GetRoleAsync(role.RoleId);

            if (roleFromDb == null)
            {
                return (true, null);
            }

            var errors = await ValidateRoleDtoAsync(role);

            if (role.Name != roleFromDb.Name)
            {
                if (await _roleRepo.DoesNameExistAsync(role.Name))
                {
                    errors.AddItem(Fields.Username, $"The role name [{role.Name}] already exists.");
                }
            }

            if (errors.Count > 0)
            {
                return (false, errors);
            }

            await _roleRepo.UpdateRoleAsync(role);

            _unitOfWork.Commit();

            return (false, errors);
        }
    }
}
