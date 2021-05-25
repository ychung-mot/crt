using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model.Dtos.Ratio;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.Ratio
{
    public class RatioServiceShould
    {
        [Theory]
        [AutoMoqData]
        public void CreateRatioSuccessfullyWhenValid(RatioCreateDto ratioCreateDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));

            //act
            var result = sut.CreateRatioAsync(ratioCreateDto).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateRatioWhenDistrictDoesntExist(RatioCreateDto ratioCreateDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(false));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));

            //act
            var result = sut.CreateRatioAsync(ratioCreateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateRatioWhenServiceAreaDoesntExist(RatioCreateDto ratioCreateDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(false));

            //act
            var result = sut.CreateRatioAsync(ratioCreateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void DeleteRatioSuccessfully(RatioDto ratioDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            decimal projectId = 1;
            ratioDto.ProjectId = projectId;

            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(ratioDto));

            //act
            var result = sut.DeleteRatioAsync(projectId, It.IsAny<decimal>()).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteRatioWhenRatioDoesntExist(
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult<RatioDto>(null));

            //act
            var result = sut.DeleteRatioAsync(It.IsAny<decimal>(), It.IsAny<decimal>()).Result;

            //assert
            Assert.Null(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteRatioWhenWrongProject(RatioDto ratioDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            ratioDto.ProjectId = 99;
            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(ratioDto));

            //act
            var result = sut.DeleteRatioAsync(1, It.IsAny<decimal>()).Result;

            //assert
            Assert.Null(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void UpdateRatioSuccessfullyWhenValid(RatioUpdateDto ratioUpdateDto,
            RatioDto ratioDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            ratioDto.ProjectId = 1;
            ratioUpdateDto.ProjectId = 1;

            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(ratioDto));

            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));

            //act
            var result = sut.UpdateRatioAsync(ratioUpdateDto).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);

        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateRatioWhenWrongProject(RatioUpdateDto ratioUpdateDto,
            RatioDto ratioDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            ratioDto.ProjectId = 1;
            ratioUpdateDto.ProjectId = 99;

            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(ratioDto));

            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));

            //act
            var result = sut.UpdateRatioAsync(ratioUpdateDto).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);

        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateRatioWhenRatioDoesntExist(RatioUpdateDto ratioUpdateDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult<RatioDto>(null));

            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));

            //act
            var result = sut.UpdateRatioAsync(ratioUpdateDto).Result;

            //assert
            Assert.Null(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);

        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateRatioWhenServiceAreaDoesntExist(RatioUpdateDto ratioUpdateDto,
            RatioDto ratioDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            ratioDto.ProjectId = 1;
            ratioUpdateDto.ProjectId = 99;

            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(ratioDto));

            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(false));

            //act
            var result = sut.UpdateRatioAsync(ratioUpdateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);

        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateRatioWhenDistrictDoesntExist(RatioUpdateDto ratioUpdateDto,
            RatioDto ratioDto,
            [Frozen] Mock<IRatioRepository> mockRatioRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            RatioService sut)
        {
            //arrange
            ratioDto.ProjectId = 1;
            ratioUpdateDto.ProjectId = 99;

            mockRatioRepo.Setup(x => x.GetRatioByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(ratioDto));

            mockRatioRepo.Setup(x => x.DistrictExists(It.IsAny<decimal>())).Returns(Task.FromResult(false));
            mockRatioRepo.Setup(x => x.ServiceAreaExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));

            //act
            var result = sut.UpdateRatioAsync(ratioUpdateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);

        }
    }
}
