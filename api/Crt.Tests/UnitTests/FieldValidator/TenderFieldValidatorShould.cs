using AutoFixture.Xunit2;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Tender;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.FieldValidator
{
    public class TenderFieldValidatorShould
    {
        static class CodeLookup
        {
            public const decimal WinningCntrctrLkupId = 409;
        }

        private List<CodeLookupDto> GetMockedCodeLookup()
        {
            List<CodeLookupDto> codeLookup = new List<CodeLookupDto>();
            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = CodeLookup.WinningCntrctrLkupId,
                CodeSet = CodeSet.Contractor,
                CodeName = "Test Contractor",
                CodeValueFormat = "STRING",
                DisplayOrder = 1,
            });

            return codeLookup;
        }

        private TenderCreateDto GetValidTenderCreateDto()
        {
            return new TenderCreateDto
            {
                TenderNumber = "T001-P001",
                PlannedDate = DateTime.Now.Date,
                ActualDate = DateTime.Now.Date,
                TenderValue = 50000.00M,
                WinningCntrctrLkupId = CodeLookup.WinningCntrctrLkupId,
                BidValue = 45000.00M,
                Comment = "Test Valid Comment",
                EndDate = null
            };
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsSuccessWhenTenderIsValid(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            //act
            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            //assert
            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenTenderNumberLengthIs41(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();
            
            sut.CodeLookup = GetMockedCodeLookup();
            
            //invalid tender number
            tenderCreate.TenderNumber = new string('A', 41);

            //act
            errors = sut.Validate(Entities.Tender, tenderCreate, errors);
            
            //assert
            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenTenderNumberLengthIs0(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();
            
            sut.CodeLookup = GetMockedCodeLookup();
            
            tenderCreate.TenderNumber = "";
            
            errors = sut.Validate(Entities.Tender, tenderCreate, errors);
            
            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenTenderValueExceedsLengthOf9(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            tenderCreate.TenderValue = 1234567891.00M;

            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenTenderValueDecimalExceedsLengthOf2(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            tenderCreate.TenderValue = 123456789.001M;

            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenBidValueExceedsLengthOf9(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            tenderCreate.BidValue = 1234567891.00M;

            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenBidValueDecimalExceedsLengthOf2(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            tenderCreate.BidValue = 123456789.001M;

            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenContractorIdDoesntExistInCodeLookup(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            tenderCreate.WinningCntrctrLkupId = 123;

            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenCommentExceedsLengthOf2000(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            TenderCreateDto tenderCreate = GetValidTenderCreateDto();

            sut.CodeLookup = GetMockedCodeLookup();

            tenderCreate.Comment = new string('A', 2001);

            errors = sut.Validate(Entities.Tender, tenderCreate, errors);

            Assert.NotEmpty(errors);
        }
    }
}
