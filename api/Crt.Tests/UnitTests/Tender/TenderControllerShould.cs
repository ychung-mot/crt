using AutoFixture.Xunit2;
using Crt.Api.Controllers;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.Project;
using Crt.Model.Dtos.Tender;
using Crt.Model.Dtos.User;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.Tender
{
    public class TenderControllerShould
    {
        static class Lookup
        {
            public const decimal ProjectId = 1;
            public const decimal RegionId = 2;
            public const decimal TenderId = 1;
        }

        private Mock<CrtCurrentUser> mockCurrentUser = new Mock<CrtCurrentUser>();
        private Mock<ITenderService> mockTenderService = new Mock<ITenderService>();
        private Mock<IProjectService> mockProjectService = new Mock<IProjectService>();

        private ProjectDto GetMockedProjectDto()
        {
            return new ProjectDto
            {
                ProjectId = Lookup.ProjectId,
                RegionId = Lookup.RegionId,
            };
        }

        private UserCurrentDto GetMockedUserCurrentDto()
        {
            var regionIds = new List<Decimal>();
            regionIds.Add(Lookup.RegionId);
            
            return new UserCurrentDto
            {
                RegionIds = regionIds.ToArray(),
            };
        }

        private TenderDto GetMockedTenderDto()
        {
            return new TenderDto
            {
                ProjectId = Lookup.ProjectId,
                TenderId = Lookup.TenderId,
            };
        }

        [Fact]
        public async Task ReturnTenderWhenValid()
        {
            //arrange
            var projectId = Lookup.ProjectId;

            mockCurrentUser.Object.UserInfo = GetMockedUserCurrentDto();
            mockTenderService.Setup(x => x.GetTenderByIdAsync(projectId)).Returns(Task.FromResult<TenderDto>(GetMockedTenderDto()));
            mockProjectService.Setup(x => x.GetProjectAsync(projectId)).Returns(Task.FromResult<ProjectDto>(GetMockedProjectDto()));

            var tenderCtrllr = new TenderController(mockCurrentUser.Object, mockProjectService.Object, 
                mockTenderService.Object);

            //act
            var actionResult = await tenderCtrllr.GetTenderByIdAsync(projectId, Lookup.TenderId);

            //assert
            var result = Assert.IsType<OkObjectResult>(actionResult.Result);
            var returnValue = Assert.IsType<TenderDto>(result.Value);

            Assert.Equal(1, returnValue.ProjectId);
            Assert.Equal(1, returnValue.TenderId);
        }

        [Fact]
        public async Task ReturnNotFoundWhenTenderDoesntExist()
        {
            //arrange
            var projectId = Lookup.ProjectId;

            mockCurrentUser.Object.UserInfo = GetMockedUserCurrentDto();
            mockTenderService.Setup(x => x.GetTenderByIdAsync(projectId)).Returns(Task.FromResult<TenderDto>(GetMockedTenderDto()));
            mockProjectService.Setup(x => x.GetProjectAsync(projectId)).Returns(Task.FromResult<ProjectDto>(GetMockedProjectDto()));

            var tenderCtrllr = new TenderController(mockCurrentUser.Object, mockProjectService.Object,
                mockTenderService.Object);

            //act
            var actionResult = await tenderCtrllr.GetTenderByIdAsync(projectId, 2);

            //assert
            Assert.IsType<NotFoundResult>(actionResult.Result);
        }

        [Fact]
        public async Task ReturnNotFoundWhenProjectDoesntExist()
        {
            //arrange
            var projectId = Lookup.ProjectId;

            mockCurrentUser.Object.UserInfo = GetMockedUserCurrentDto();
            mockTenderService.Setup(x => x.GetTenderByIdAsync(projectId)).Returns(Task.FromResult<TenderDto>(GetMockedTenderDto()));
            mockProjectService.Setup(x => x.GetProjectAsync(projectId)).Returns(Task.FromResult<ProjectDto>(GetMockedProjectDto()));

            var tenderCtrllr = new TenderController(mockCurrentUser.Object, mockProjectService.Object,
                mockTenderService.Object);

            //act
            var actionResult = await tenderCtrllr.GetTenderByIdAsync(2, Lookup.TenderId);

            //assert
            Assert.IsType<NotFoundResult>(actionResult.Result);
        }
    }
}
