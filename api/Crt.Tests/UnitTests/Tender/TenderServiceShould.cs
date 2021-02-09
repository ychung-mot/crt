using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model.Dtos.Tender;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.Tender
{
    public class TenderServiceShould
    {
        [Theory]
        [AutoMoqData]
        public void CreateTenderSuccessfullyWhenValid(TenderCreateDto tender,
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            mockTenderRepo.Setup(x => x.TenderNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<string>()))
                .Returns(Task.FromResult(false));

            //act
            var result = sut.CreateTenderAsync(tender).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateTenderWhenFieldsInvalid(TenderCreateDto tender,
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            TenderService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            errors.Add("Error", new List<string>(new string[] { "Invalid Field Value Error" }));

            mockTenderRepo.Setup(x => x.TenderNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<string>()))
                .Returns(Task.FromResult(false));

            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<TenderSaveDto>(), It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);

            //act
            var result = sut.CreateTenderAsync(tender).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateTenderWhenTenderAlreadyExists(TenderCreateDto tender,
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            mockTenderRepo.Setup(x => x.TenderNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<string>()))
                .Returns(Task.FromResult(true));

            //act
            var result = sut.CreateTenderAsync(tender).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void UpdateTenderSuccessfullyWhenValid(TenderUpdateDto tenderUpdate,
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            mockTenderRepo.Setup(x => x.TenderNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<string>()))
                .Returns(Task.FromResult(false));    //false because it doesn't return itself

            mockTenderRepo.Setup(x => x.GetTenderByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(new TenderDto()));

            //act
            var result = sut.UpdateTenderAsync(tenderUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateTenderWhenTenderNotFound(TenderUpdateDto tenderUpdate,
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            mockTenderRepo.Setup(x => x.TenderNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<string>()))
                .Returns(Task.FromResult(false));   //false because it doesn't return itself

            mockTenderRepo.Setup(x => x.GetTenderByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult<TenderDto>(null));

            //act
            var result = sut.UpdateTenderAsync(tenderUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateTenderWhenFieldsInvalid(TenderUpdateDto tenderUpdate,
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<IFieldValidatorService> mockFieldValidator,
            TenderService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            errors.Add("Error", new List<string>(new string[] { "Invalid Field Value Error" }));


            //arrange
            mockFieldValidator.Setup(x => x.Validate(It.IsAny<string>(), It.IsAny<TenderSaveDto>(), It.IsAny<Dictionary<string, List<string>>>(), It.IsAny<int>()))
                .Returns(errors);
            
            mockTenderRepo.Setup(x => x.TenderNumberAlreadyExists(It.IsAny<decimal>(), It.IsAny<decimal>(), It.IsAny<string>()))
                .Returns(Task.FromResult(false));    //false because it doesn't return itself

            mockTenderRepo.Setup(x => x.GetTenderByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(new TenderDto()));

            //act
            var result = sut.UpdateTenderAsync(tenderUpdate).Result;

            //assert
            Assert.NotEmpty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void DeleteTenderSuccessfullyWhenFound(
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            TenderDto tender = new TenderDto
            {
                ProjectId = 1,
                TenderId = 1
            };

            mockTenderRepo.Setup(x => x.GetTenderByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(tender));

            mockTenderRepo.Setup(x => x.DeleteTenderAsync(It.IsAny<decimal>()));

            //act
            var result = sut.DeleteTenderAsync(tender.ProjectId, tender.TenderId).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteTenderWhenWrongProject(
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            decimal projectId = 2;

            TenderDto tender = new TenderDto
            {
                ProjectId = 1,
                TenderId = 1
            };

            mockTenderRepo.Setup(x => x.GetTenderByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(tender));

            mockTenderRepo.Setup(x => x.DeleteTenderAsync(It.IsAny<decimal>()));

            //act
            var result = sut.DeleteTenderAsync(projectId, tender.TenderId).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteTenderWhenTenderDoesntExist(
            [Frozen] Mock<ITenderRepository> mockTenderRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            TenderService sut)
        {
            //arrange
            mockTenderRepo.Setup(x => x.GetTenderByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult<TenderDto>(null));

            mockTenderRepo.Setup(x => x.DeleteTenderAsync(It.IsAny<decimal>()));

            //act
            var result = sut.DeleteTenderAsync(It.IsAny<decimal>(), It.IsAny<decimal>()).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
