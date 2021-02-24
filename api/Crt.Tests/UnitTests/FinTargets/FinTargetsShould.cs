using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.FinTarget;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.FinTargets
{
    public class FinTargetsShould
    {
        [Theory]
        [AutoMoqData]
        public void CreateFinTargetWhenValid(FinTargetCreateDto finTargetCreateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IFinTargetRepository> mockFinTargetRepo,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            FinTargetService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            
            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<FinTargetCreateDto>()
                , It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            mockFinTargetRepo.Setup(x => x.ElementExists(It.IsAny<decimal>())).Returns(Task.FromResult(true));
            
            //act
            var result = sut.CreateFinTargetAsync(finTargetCreateDto).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateFinTargetWhenElementIdInvalid(FinTargetCreateDto finTargetCreateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IFinTargetRepository> mockFinTargetRepo,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            FinTargetService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            
            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<FinTargetCreateDto>()
                , It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            mockFinTargetRepo.Setup(x => x.ElementExists(It.IsAny<decimal>())).Returns(Task.FromResult(false));

            //act
            var result = sut.CreateFinTargetAsync(finTargetCreateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateFinTargetWhenValidationFails(FinTargetCreateDto finTargetCreateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IFinTargetRepository> mockFinTargetRepo,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            FinTargetService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            errors.Add("Error", new List<string>(new string[] { "Error occurred" }));

            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<FinTargetCreateDto>()
                , It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            mockFinTargetRepo.Setup(x => x.ElementExists(It.IsAny<decimal>())).Returns(Task.FromResult(false));

            //act
            var result = sut.CreateFinTargetAsync(finTargetCreateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void UpdateFinTargetWhenValid(FinTargetUpdateDto finTargetUpdateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IFinTargetRepository> mockFinTargetRepo,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            FinTargetService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            var finTargetDto = new FinTargetDto();

            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<FinTargetCreateDto>()
                , It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            mockFinTargetRepo.Setup(x => x.ElementExists(It.IsAny<decimal>()))
                .Returns(Task.FromResult(true));

            finTargetDto.ProjectId = finTargetUpdateDto.ProjectId;
            mockFinTargetRepo.Setup(x => x.GetFinTargetByIdAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(finTargetDto));

            //act
            var result = sut.UpdateFinTargetAsync(finTargetUpdateDto).Result;

            //assert
            Assert.Empty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateFinTargetWhenDoesntExist(FinTargetUpdateDto finTargetUpdateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            //[Frozen] Mock<IUserRepository> mockUserRepo,
            [Frozen] Mock<IFinTargetRepository> mockFinTargetRepo,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            FinTargetService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            var finTargetDto = new FinTargetDto();

            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<FinTargetCreateDto>()
                , It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            mockFinTargetRepo.Setup(x => x.ElementExists(It.IsAny<decimal>()))
                .Returns(Task.FromResult(true));

            finTargetDto.ProjectId = 0; //mock will never set the id to zero
            mockFinTargetRepo.Setup(x => x.GetFinTargetByIdAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(finTargetDto));

            //act
            var result = sut.UpdateFinTargetAsync(finTargetUpdateDto).Result;

            //assert
            Assert.Null(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
