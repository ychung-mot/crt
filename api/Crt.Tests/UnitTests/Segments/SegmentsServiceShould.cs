using AutoFixture.Xunit2;
using Crt.Data.Database;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Crt.HttpClients.Models;
using Crt.Model;
using Crt.Model.Dtos.Segments;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace Crt.Tests.UnitTests.Segments
{
    public class SegmentsServiceShould
    {
        [Theory]
        [AutoMoqData]
        public void CreateSegmentSuccessfullyWhenValid(SegmentCreateDto segmentCreateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            SegmentService sut)
        {
            //arrange
            
            //act
            var result = sut.CreateSegmentAsync(segmentCreateDto).Result;

            //assert
            Assert.Empty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailCreateWhenRouteHasSinglePoint(SegmentCreateDto segmentCreateDto,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            SegmentService sut)
        {
            //arrange
            decimal[][] singlePoint = new decimal[][] { new decimal[]{ 23.000M , -127.000M } };
            segmentCreateDto.Route = singlePoint;

            //act
            var result = sut.CreateSegmentAsync(segmentCreateDto).Result;

            //assert
            Assert.NotEmpty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }

        [Theory]
        [AutoMoqData]
        public void DeleteSegmentSuccessfully(SegmentListDto segmentListDto,
            [Frozen] Mock<ISegmentRepository> mockSegmentRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            SegmentService sut)
        {
            //arrange
            var projectId = 1;
            
            segmentListDto.ProjectId = projectId;
            mockSegmentRepo.Setup(x => x.GetSegmentByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(segmentListDto));

            //act
            var result = sut.DeleteSegmentAsync(projectId, It.IsAny<decimal>()).Result;

            //assert
            Assert.Empty(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Once);
        }

        [Theory]
        [AutoMoqData]
        public void FailToDeleteSegmentWhenWrongProject(SegmentListDto segmentListDto,
            [Frozen] Mock<ISegmentRepository> mockSegmentRepo,
            [Frozen] Mock<IUnitOfWork> mockUnitOfWork,
            SegmentService sut)
        {
            //arrange
            segmentListDto.ProjectId = 1;
            mockSegmentRepo.Setup(x => x.GetSegmentByIdAsync(It.IsAny<decimal>())).Returns(Task.FromResult(segmentListDto));

            //act
            var result = sut.DeleteSegmentAsync(2, It.IsAny<decimal>()).Result;

            //assert
            Assert.Null(result.Errors);
            mockUnitOfWork.Verify(x => x.Commit(), Times.Never);
        }
    }
}
