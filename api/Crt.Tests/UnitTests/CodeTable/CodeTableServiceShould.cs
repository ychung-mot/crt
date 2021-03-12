using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.Model;
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

        [Theory]
        [AutoMoqData]
        public void UpdateCodeLookupSuccessfullyWhenValid(CodeLookupUpdateDto codeLookupUpdateDto,
            CodeLookupDto codeLookupDto,
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            
            mockCodeLookupRepo.Setup(x => x.GetCodeLookupByIdAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(codeLookupDto));

            //act
            var result = sut.UpdateCodeLookupAsync(codeLookupUpdateDto).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToUpdateCodeLookupWhenDoesntExist(CodeLookupUpdateDto codeLookupUpdateDto,
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            mockCodeLookupRepo.Setup(x => x.GetCodeLookupByIdAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult<CodeLookupDto>(null));

            //act
            var result = sut.UpdateCodeLookupAsync(codeLookupUpdateDto).Result;

            //assert
            Assert.Null(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void DeleteCodeLookupSuccessfully(CodeLookupDto codeLookupDto,
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            mockCodeLookupRepo.Setup(x => x.GetCodeLookupByIdAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(codeLookupDto));
            
            //act
            var result = sut.DeleteCodeLookupAsync(It.IsAny<decimal>()).Result;

            //assert
            Assert.Empty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteCodeLookupWhenDoesntExist(
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            mockCodeLookupRepo.Setup(x => x.GetCodeLookupByIdAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult<CodeLookupDto>(null));
            
            //act
            var result = sut.DeleteCodeLookupAsync(It.IsAny<decimal>()).Result;

            //assert
            Assert.Null(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteCodeLookupWhenIsReferenced(
            [Frozen] Mock<ICodeLookupRepository> mockCodeLookupRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            CodeTableService sut)
        {
            //arrange
            mockCodeLookupRepo.Setup(x => x.IsCodeLookupInUseAsync(It.IsAny<decimal>()))
                .Returns(Task.FromResult(true));
            
            //act
            var result = sut.DeleteCodeLookupAsync(It.IsAny<decimal>()).Result;

            //assert
            Assert.NotEmpty(result.errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
