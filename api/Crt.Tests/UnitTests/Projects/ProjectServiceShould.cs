using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Project;
using Crt.Model.Dtos.User;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.Project
{
    static class Lookup
    {
        public const decimal ProjectId = 1;
        public const decimal RegionId = 2;
        public const decimal TenderId = 3;
        public const decimal CapIndxLkupId = 4;
        public const decimal Rc = 5;
        public const decimal ManagerId = 6;
    }

    public class ProjectServiceShould
    {
        private Mock<CrtCurrentUser> mockCurrentUser = new Mock<CrtCurrentUser>();
        private ProjectCreateDto projectCreateDto = new ProjectCreateDto();
        private ProjectUpdateDto projectUpdateDto = new ProjectUpdateDto();

        private List<CodeLookupDto> GetMockedCodeLookup()
        {
            List<CodeLookupDto> codeLookup = new List<CodeLookupDto>();
            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = Lookup.CapIndxLkupId,
                CodeSet = CodeSet.CapIndx,
                CodeName = "Capital Index Lookup",
                CodeValueFormat = "STRING",
                DisplayOrder = 1,
            });

            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = Lookup.Rc,
                CodeSet = CodeSet.Rc,
                CodeName = "WR Bennett Bridge",
                CodeValueText = "55080",
                CodeValueFormat = "STRING",
                DisplayOrder = 1,
            });
            return codeLookup;
        }

        private UserCurrentDto GetMockedUserCurrentDto(decimal regionId = Lookup.RegionId)
        {
            var regionIds = new List<decimal>();
            regionIds.Add(regionId);

            return new UserCurrentDto
            {
                RegionIds = regionIds.ToArray(),
            };
        }

        private IEnumerable<UserManagerDto> GetMockedUserManagers()
        {
            var managers = new List<UserManagerDto>();
            managers.Add(new UserManagerDto
            {
                SystemUserId = Lookup.ManagerId,
                FirstName = "Test",
                LastName = "User",
            });

            return managers;
        }

        private ProjectCreateDto GetMockedProjectCreateDto()
        {
            return new ProjectCreateDto
            {
                CapIndxLkupId = Lookup.CapIndxLkupId,
                RcLkupId = Lookup.Rc,
                ProjectMgrId = Lookup.ManagerId,
                ProjectNumber = "P001-Test Project 001",
                ProjectName = "Test Project Name",
                RegionId = Lookup.RegionId,
                //Scope = ??,
                //NearstTwnLkupId = ??,
                //AnncmentValue = ??,
                //C035Value = ??
                //AnncmentComment = ??
            };
        }

        private ProjectUpdateDto GetMockedProjectUpdateDto()
        {
            var pud = new ProjectUpdateDto
            {
                CapIndxLkupId = Lookup.CapIndxLkupId,
                RcLkupId = Lookup.Rc,
                ProjectMgrId = Lookup.ManagerId,
                ProjectNumber = "P001-Test Project 001",
                ProjectName = "Test Project Name",
                RegionId = Lookup.RegionId,
                //Scope = ??,
                //NearstTwnLkupId = ??,
                //AnncmentValue = ??,
                //C035Value = ??
                //AnncmentComment = ??
            };
            pud.ProjectId = Lookup.ProjectId;
            return pud;
        }

        private void GetManuallyMockedObjects()
        {
            projectCreateDto = GetMockedProjectCreateDto();
            projectUpdateDto = GetMockedProjectUpdateDto();
            mockCurrentUser.Object.UserInfo = GetMockedUserCurrentDto();
        }
         
        [Theory]
        [AutoMoqData]
        public void CreateProjectWhenValid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.ProjectNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(Task.FromResult(false));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.CreateProjectAsync(projectCreateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateProjectWhenUserIsntInRegion(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            projectCreateDto.RegionId = 99; //bad region submitted

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.ProjectNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(Task.FromResult(false));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.CreateProjectAsync(projectCreateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateProjectWhenInvalidManager(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            projectCreateDto.ProjectMgrId = 99; //invalid manager id

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.ProjectNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(Task.FromResult(false));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.CreateProjectAsync(projectCreateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateProjectWhenProjectAlreadyExists(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            
            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.ProjectNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(Task.FromResult(true));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.CreateProjectAsync(projectCreateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void UpdateProjectWhenValid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.GetProjectAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(new ProjectDto { ProjectId = Lookup.ProjectId }));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.UpdateProjectAsync(projectUpdateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateProjectWhenInvalidManager(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            projectCreateDto.ProjectMgrId = 99; //invalid manager id

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.GetProjectAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(new ProjectDto { ProjectId = Lookup.ProjectId }));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.UpdateProjectAsync(projectUpdateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateProjectWhenUserIsntInRegion(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            projectCreateDto.RegionId = 99; //invalid region

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.GetProjectAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(new ProjectDto { ProjectId = Lookup.ProjectId }));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.UpdateProjectAsync(projectUpdateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateProjectWhenProjectDoesntExist(FieldValidatorService fieldValidator,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IProjectRepository> mockProjectRepo)
        {
            //arrange
            GetManuallyMockedObjects();
            fieldValidator.CodeLookup = GetMockedCodeLookup();

            mockUserRepo.Setup(x => x.GetManagersAsync())
                .Returns(Task.FromResult(GetMockedUserManagers()));

            mockProjectRepo.Setup(x => x.GetProjectAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult<ProjectDto>(null));

            //instantiate the project service with the mocked objects
            var mockProjectService = new ProjectService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockProjectRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockProjectService.UpdateProjectAsync(projectUpdateDto);

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }
    }
}
