using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model.Dtos.Role;
using Moq;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.Role
{
    public class RoleServiceShould
    {
        [Theory]        
        [AutoMoqData]
        public void CreateRoleSucceedsWhenValid(RoleCreateDto role,
            //IFixture fixture, 
            [Frozen] Mock<IRoleRepository> mockRoleRepo, 
            //[Frozen] Mock<IUserRoleRepository> mockUserRoleRepo,
            [Frozen] Mock<IPermissionRepository> mockPermissionRepo, 
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork, 
            //[Frozen] Mock<IFieldValidatorService> mockFieldVlaidator, 
            RoleService sut)
        {
            //role name doesn't exist
            mockRoleRepo.Setup<Task<bool>>(x => x.DoesNameExistAsync(It.IsAny<string>())).Returns(Task.FromResult(false));

            //all permissions are active
            mockPermissionRepo.Setup<Task<int>>(x => x.CountActivePermissionIdsAsnyc(It.IsAny<List<decimal>>())).Returns(Task.FromResult(role.Permissions.Count));

            var result = sut.CreateRoleAsync(role).Result;

            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void CreateRoleFailsWhenFieldsAreInvalid(RoleCreateDto role,
            //IFixture fixture, 
            [Frozen] Mock<IRoleRepository> mockRoleRepo,
            //[Frozen] Mock<IUserRoleRepository> mockUserRoleRepo,
            [Frozen] Mock<IPermissionRepository> mockPermissionRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IFieldValidatorService> mockFieldVlaidator, 
            RoleService sut)
        {
            var errors = new Dictionary<string, List<string>>();
            errors.Add("Error", new List<string>(new string[] { "Error occurred" }));

            //role name doesn't exist
            mockRoleRepo.Setup<Task<bool>>(x => x.DoesNameExistAsync(It.IsAny<string>())).Returns(Task.FromResult(false));

            //all permissions are active
            mockPermissionRepo.Setup<Task<int>>(x => x.CountActivePermissionIdsAsnyc(It.IsAny<List<decimal>>())).Returns(Task.FromResult(role.Permissions.Count));

            //validation error
            mockFieldVlaidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<IRoleSaveDto>(), It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            var result = sut.CreateRoleAsync(role).Result;

            Assert.NotEmpty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void CreateRoleFailsWhenRoleExists(RoleCreateDto role,
            //IFixture fixture, 
            [Frozen] Mock<IRoleRepository> mockRoleRepo,
            //[Frozen] Mock<IUserRoleRepository> mockUserRoleRepo,
            [Frozen] Mock<IPermissionRepository> mockPermissionRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IFieldValidatorService> mockFieldVlaidator,
            RoleService sut)
        {
            //role name exists
            mockRoleRepo.Setup<Task<bool>>(x => x.DoesNameExistAsync(It.IsAny<string>())).Returns(Task.FromResult(true));

            //all permissions are active
            mockPermissionRepo.Setup<Task<int>>(x => x.CountActivePermissionIdsAsnyc(It.IsAny<List<decimal>>())).Returns(Task.FromResult(role.Permissions.Count));

            var result = sut.CreateRoleAsync(role).Result;

            Assert.NotEmpty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void CreateRoleFailsWhenInActivePermissionExists(RoleCreateDto role,
            //IFixture fixture, 
            [Frozen] Mock<IRoleRepository> mockRoleRepo,
            //[Frozen] Mock<IUserRoleRepository> mockUserRoleRepo,
            [Frozen] Mock<IPermissionRepository> mockPermissionRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IFieldValidatorService> mockFieldVlaidator,
            RoleService sut)
        {
            //role name doesn't exist
            mockRoleRepo.Setup<Task<bool>>(x => x.DoesNameExistAsync(It.IsAny<string>())).Returns(Task.FromResult(false));

            //all permissions are active
            mockPermissionRepo.Setup<Task<int>>(x => x.CountActivePermissionIdsAsnyc(It.IsAny<List<decimal>>())).Returns(Task.FromResult(role.Permissions.Count - 1));

            var result = sut.CreateRoleAsync(role).Result;

            Assert.NotEmpty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
