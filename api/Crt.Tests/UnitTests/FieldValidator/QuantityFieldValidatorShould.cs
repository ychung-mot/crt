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
    static class CodeLookup
    {
        public const decimal Quantity = 1;
        public const decimal FiscalYear = 2;
        public const decimal Accomplishment = 3;
    }

    public class QuantityFieldValidatorShould
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

            return codeLookup;
        }

        private QtyAccmpSaveDto GetValidQuantitySaveDto()
        {
            return new QtyAccmpSaveDto
            {
                ProjectId = 1,
                FiscalYearLkupId = CodeLookup.FiscalYear,
                Forecast = 100.00M,
                Schedule7 = 100.00M,
                Comment = "Test Quantity",
                QtyAccmpLkupId = CodeLookup.Quantity,
            };
        }

        [Theory]
        [AutoMoqData]
        public void ReturnSuccessWhenQuantityFieldsAreValid(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();

            sut.CodeLookup = GetMockedCodeLookup();

            //act
            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            //assert
            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenInvalidQtyAccmpLkupId(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();
            qtyAccmpSave.QtyAccmpLkupId = 99;

            sut.CodeLookup = GetMockedCodeLookup();
            
            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenInvalidFiscalYearLkpId(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();
            qtyAccmpSave.FiscalYearLkupId = 99;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        //Value must be a number of less than 10 digits optionally with maximum 2 decimal digits
        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenInvalidForecastAmount(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();
            qtyAccmpSave.Forecast = 12345678901M;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenInvalidSchedule7Amount(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();
            qtyAccmpSave.Schedule7 = 12345678.0000M;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenInvalidActualAmount(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();
            qtyAccmpSave.Actual = 1234567891.0000M;

            sut.CodeLookup = GetMockedCodeLookup();

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorWhenCommentExceedsMaxLength(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            QtyAccmpSaveDto qtyAccmpSave = GetValidQuantitySaveDto();

            sut.CodeLookup = GetMockedCodeLookup();

            qtyAccmpSave.Comment = new string('A', 2001);

            errors = sut.Validate(Entities.Qty, qtyAccmpSave, errors);

            Assert.NotEmpty(errors);
        }
    }
}
