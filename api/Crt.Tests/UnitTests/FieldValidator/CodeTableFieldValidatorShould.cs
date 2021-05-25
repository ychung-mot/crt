using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.CodeLookup;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.FieldValidator
{
    public class CodeTableFieldValidatorShould
    {
        [Theory]
        [AutoMoqData]
        public void ReturnSuccessWhenCodeLookupFieldsAreValid(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            CodeLookupDto codeLookupDto = new CodeLookupDto
            {
                CodeName = "CodeNameTest",
                CodeValueText = "CodeValueTest"
            };
            
            //act
            errors = sut.Validate(Entities.CodeTable, codeLookupDto, errors);

            //assert
            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        
        public void ReturnErrorWhenCodeNameExceeds255Chars(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            CodeLookupDto codeLookupDto = new CodeLookupDto
            {
                CodeName = new string('A', 256),
                CodeValueText = "CodeValueTest"
            };

            //act
            errors = sut.Validate(Entities.CodeTable, codeLookupDto, errors);

            //assert
            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]

        public void ReturnErrorWhenCodeNameIsMissing(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            CodeLookupDto codeLookupDto = new CodeLookupDto
            {
                CodeName = null,
                CodeValueText = "CodeValueTest"
            };

            //act
            errors = sut.Validate(Entities.CodeTable, codeLookupDto, errors);

            //assert
            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]

        public void ReturnErrorWhenCodeValueExceeds20Chars(FieldValidatorService sut)
        {
            //arrange
            var errors = new Dictionary<string, List<string>>();
            CodeLookupDto codeLookupDto = new CodeLookupDto
            {
                CodeName = "CodeNameTest",
                CodeValueText = new string('A', 21)
            };

            //act
            errors = sut.Validate(Entities.CodeTable, codeLookupDto, errors);

            //assert
            Assert.NotEmpty(errors);
        }
    }
}
