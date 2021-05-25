using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using Crt.Model.Dtos.Ratio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.FieldValidator
{
    public class RatioFieldValidatorShould
    {
        static class CodeLookup
        {
            public const decimal RatioRecordTypeId = 766;
        }

        private List<CodeLookupDto> GetMockedCodeLookup()
        {
            List<CodeLookupDto> codeLookup = new List<CodeLookupDto>();
            codeLookup.Add(new CodeLookupDto
            {
                CodeLookupId = CodeLookup.RatioRecordTypeId,
                CodeSet = CodeSet.RatioRecordType,
                CodeName = "Electoral District",
                CodeValueFormat = "STRING",
                DisplayOrder = 1,
            });

            return codeLookup;
        }

        [Theory]
        [AutoMoqData]
        public void ReturnSuccessWhenCreateDtoIsValid(RatioCreateDto ratioCreateDto,
            FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            sut.CodeLookup = GetMockedCodeLookup();

            ratioCreateDto.RatioRecordTypeLkupId = CodeLookup.RatioRecordTypeId;

            //act
            errors = sut.Validate(Entities.Ratio, ratioCreateDto, errors);

            //assert
            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenRatioRecordTypeIsInvalid(RatioCreateDto ratioCreateDto,
            FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            sut.CodeLookup = GetMockedCodeLookup();

            ratioCreateDto.RatioRecordTypeLkupId = 99;

            //act
            errors = sut.Validate(Entities.Ratio, ratioCreateDto, errors);

            //assert
            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnErrorWhenRatioValueIsInvalid(RatioCreateDto ratioCreateDto,
            FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            sut.CodeLookup = GetMockedCodeLookup();

            ratioCreateDto.RatioRecordTypeLkupId = CodeLookup.RatioRecordTypeId;
            ratioCreateDto.Ratio = 1234567890.12345M;

            //act
            errors = sut.Validate(Entities.Ratio, ratioCreateDto, errors);

            //assert
            Assert.NotEmpty(errors);
        }
    }
}
