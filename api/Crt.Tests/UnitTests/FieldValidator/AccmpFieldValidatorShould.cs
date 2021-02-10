using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.QtyAccmp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.FieldValidator
{
    public class AccmpFieldValidatorShould
    {
        static class CodeLookup
        {
            public const decimal Quantity = 1;
            public const decimal FiscalYear = 2;
            public const decimal Accomplishment = 3;
        }

        private QtyAccmpSaveDto GetValidAccomplishmentSaveDto()
        {
            return new QtyAccmpSaveDto
            {
                ProjectId = 1,
                FiscalYearLkupId = CodeLookup.FiscalYear,
                Forecast = 100.00M,
                Schedule7 = 100.00M,
                Comment = "Test Quantity",
                QtyAccmpLkupId = CodeLookup.Accomplishment,
            };
        }

        private List<CodeLookupDto> GetMockedCodeLookup()
        {
            List<CodeLookupDto> codeLookup = new List<CodeLookupDto>();
            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = CodeLookup.Accomplishment,
                CodeSet = CodeSet.Accomplishment,
                CodeName = "Test Accomplishment",
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

            return codeLookup;
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsSuccessWhenQuantityFieldsAreValid(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();

            sut.CodeLookup = GetMockedCodeLookup();

            //act
            errors = sut.Validate(Entities.Accmp, qtyAccmpSave, errors);

            //assert
            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenInvalidQtyAccmpLkupId(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();
            qtyAccmpSave.QtyAccmpLkupId = 99;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenInvalidFiscalYearLkpId(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();
            qtyAccmpSave.FiscalYearLkupId = 99;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        //Value must be a number of less than 8 digits optionally with maximum 3 decimal digits
        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenInvalidForecastAmount(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();
            qtyAccmpSave.Forecast = 123456789M;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenInvalidSchedule7Amount(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();
            qtyAccmpSave.Schedule7 = 12345678.0000M;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenInvalidActualAmount(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();
            qtyAccmpSave.Actual = 1234567891.0000M;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenCommentExceedsLengthOf2000(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidAccomplishmentSaveDto();

            sut.CodeLookup = GetMockedCodeLookup();

            qtyAccmpSave.Comment = new string('A', 2001);

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }
    }
}
