using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model.Dtos.CodeLookup;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.CodeTable
{
    public class CodeTableServiceShould
    {
        [Theory]
        [AutoMoqData]
        public void CreateCodeLookupSuccessfullyWhenValid(CodeLookupCreateDto codeLookupCreateDto,
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            mockCodeLookupRepo.Setup(x => x.DoesCodeLookupExistAsync(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(Task.FromResult(false));

            //act
            var result = sut.CreateCodeLookupAsync(codeLookupCreateDto).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToCreateCodeLookupWhenAlreadyExists(CodeLookupCreateDto codeLookupCreateDto,
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            mockCodeLookupRepo.Setup(x => x.DoesCodeLookupExistAsync(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(Task.FromResult(true));

            //act
            var result = sut.CreateCodeLookupAsync(codeLookupCreateDto).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
