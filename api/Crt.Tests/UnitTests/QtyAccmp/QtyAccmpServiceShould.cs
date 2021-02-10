using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Domain.Services.Base;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.QtyAccmp;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.QtyAccmp
{
    static class CodeLookup
    {
        public const decimal Quantity = 1;
        public const decimal FiscalYear = 2;
        public const decimal Accomplishment = 3;
    }

    public class QtyAccmpServiceShould
    {
        
        private List<CodeLookupDto> GetMockedCodeLookup()
        {
            List<CodeLookupDto> codeLookup = new List<CodeLookupDto>();
            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = CodeLookup.Quantity,
                CodeSet = CodeSet.Quantity,
                CodeName = "Test Quantity",
                CodeValueFormat = "STRING",
                DisplayOrder = 1,
            });

            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = CodeLookup.FiscalYear,
                CodeSet = CodeSet.FiscalYear,
                CodeName = "2021/2022",
                CodeValueFormat = "STRING",
                DisplayOrder = 1
            });

            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = CodeLookup.Accomplishment,
                CodeSet = CodeSet.Accomplishment,
                CodeName = "Test Accomplishment",
                CodeValueFormat = "STRING",
                DisplayOrder = 1
            });

            return codeLookup;
        }

        private QtyAccmpCreateDto GetQtyAccmpCreateDto()
        {
            return new QtyAccmpCreateDto
            {
                ProjectId = 1,
                FiscalYearLkupId = CodeLookup.FiscalYear,
                Forecast = 100.00M,
                Schedule7 = 100.00M,
                Comment = "Test Quantity",
            };
        }

        private QtyAccmpUpdateDto GetQtyAccmpUpdateDto()
        {
            return new QtyAccmpUpdateDto
            {
                ProjectId = 1,
                FiscalYearLkupId = CodeLookup.FiscalYear,
                Forecast = 100.00M,
                Schedule7 = 100.00M,
                Comment = "Test Quantity",
            };
        }

        [Theory]
        [AutoMoqData]
        public void CreateQuantitySuccessfullyWhenValid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            QtyAccmpCreateDto qtyAccmpCreate = GetQtyAccmpCreateDto();
            qtyAccmpCreate.QtyAccmpLkupId = CodeLookup.Quantity;

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object) ;

            //act
            var result = mockQtyAccmpService.CreateQtyAccmpAsync(qtyAccmpCreate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void CreateAccomplishmentSuccessfullyWhenValid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            QtyAccmpCreateDto qtyAccmpCreate = GetQtyAccmpCreateDto();
            qtyAccmpCreate.QtyAccmpLkupId = CodeLookup.Accomplishment;
            
            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.CreateQtyAccmpAsync(qtyAccmpCreate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateQtyAccmpWhenLkpIdIsInvalid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            QtyAccmpCreateDto qtyAccmpCreate = GetQtyAccmpCreateDto();
            qtyAccmpCreate.QtyAccmpLkupId = 99; //if the id is different the Validate entity function will fail

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.CreateQtyAccmpAsync(qtyAccmpCreate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateQtyAccmpWhenLkpIsInvalidCodeSet(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            fieldValidator.CodeLookup.First().CodeSet = CodeSet.FiscalYear;

            QtyAccmpCreateDto qtyAccmpCreate = GetQtyAccmpCreateDto();
            qtyAccmpCreate.QtyAccmpLkupId = 1; 

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.CreateQtyAccmpAsync(qtyAccmpCreate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void UpdateAccomplishmentSuccessfullyWhenValid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            QtyAccmpUpdateDto qtyAccmpUpdate = GetQtyAccmpUpdateDto();
            qtyAccmpUpdate.QtyAccmpLkupId = CodeLookup.Accomplishment;
            qtyAccmpUpdate.QtyAccmpId = 1;

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.UpdateQtyAccmpAsync(qtyAccmpUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void UpdateQuantitySuccessfullyWhenValid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            QtyAccmpUpdateDto qtyAccmpUpdate = GetQtyAccmpUpdateDto();
            qtyAccmpUpdate.QtyAccmpLkupId = CodeLookup.Quantity;
            qtyAccmpUpdate.QtyAccmpId = 1;

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.UpdateQtyAccmpAsync(qtyAccmpUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateQtyAccmpWhenLkpIdIsInvalid(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            QtyAccmpUpdateDto qtyAccmpUpdate = GetQtyAccmpUpdateDto();
            qtyAccmpUpdate.QtyAccmpLkupId = 99; //if the id is different the Validate entity function will fail

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.UpdateQtyAccmpAsync(qtyAccmpUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateQtyAccmpWhenLkpIsInvalidCodeSet(FieldValidatorService fieldValidator,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            [Frozen] Mock<CrtCurrentUser> mockCurrentUser,
            [Frozen] Mock<IUserRepository> mockUserRepo)
        {
            //arrange
            fieldValidator.CodeLookup = GetMockedCodeLookup();
            fieldValidator.CodeLookup.First().CodeSet = CodeSet.FiscalYear;

            QtyAccmpUpdateDto qtyAccmpUpdate = GetQtyAccmpUpdateDto();
            qtyAccmpUpdate.QtyAccmpLkupId = 1;

            // need to manually mock the QtyAccmpService so that I can override 
            // the fieldValidator code lookup used in the private method GetValidationEntity
            var mockQtyAccmpService = new QtyAccmpService(mockCurrentUser.Object
                , fieldValidator, mockUnitOfWork.Object, mockQtyAccmpRepo.Object
                , mockUserRepo.Object);

            //act
            var result = mockQtyAccmpService.UpdateQtyAccmpAsync(qtyAccmpUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateQtyAccmpWhenQtyAccmpDoesntExist(QtyAccmpUpdateDto qtyAccmpUpdate,
            [Frozen] Mock<IQtyAccmpRepository> mockQtyAccmpRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            QtyAccmpService sut)
        {
            //arrange
            mockQtyAccmpRepo.Setup(x => x.GetQtyAccmpByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult<QtyAccmpDto>(null));

            //act
            var result = sut.UpdateQtyAccmpAsync(qtyAccmpUpdate).Result;

            //assert
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
