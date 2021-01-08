using Crt.Domain.Services;
using Crt.Model;
using Crt.Model.Dtos.Role;
using System.Collections.Generic;
using Xunit;

namespace Crt.Tests.UnitTests.FieldValidator
{
    public class RoleFieldValidatorShould
    {
        [Theory]
        [AutoMoqData]
        public void ReturnsSuccessWhenRoleIsValid(RoleCreateDto role,
            FieldValidatorService sut)
        {
            var errors = new Dictionary<string, List<string>>();
            errors = sut.Validate(Entities.Role, role, errors);

            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsSuccessWhenRoleNameLengthIs30(
            //IFixture fixture, 
            RoleCreateDto role,
            FieldValidatorService sut)
        {
            role.Name = new string('a', 30);

            var errors = new Dictionary<string, List<string>>();
            errors = sut.Validate(Entities.Role, role, errors);

            Assert.Empty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsErrorObjecttWhenRoleNameLengthIs0(
            //IFixture fixture, 
            RoleCreateDto role,
            FieldValidatorService sut)
        {
            role.Name = "";

            var errors = new Dictionary<string, List<string>>();
            errors = sut.Validate(Entities.Role, role, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsNonEmptyErrorObjectWhenRoleDescriptionLengthIsGreaterThan150(
            //IFixture fixture, 
            RoleCreateDto role,
            FieldValidatorService sut)
        {
            role.Description = new string('a', 151);

            var errors = new Dictionary<string, List<string>>();
            errors = sut.Validate(Entities.Role, role, errors);

            Assert.NotEmpty(errors);
        }

        [Theory]
        [AutoMoqData]
        public void ReturnsNonEmptyErrorObjectWhenRoleDescriptionLengthIs0(
            //IFixture fixture, 
            RoleCreateDto role,
            FieldValidatorService sut)
        {
            role.Description = "";

            var errors = new Dictionary<string, List<string>>();
            errors = sut.Validate(Entities.Role, role, errors);

            Assert.NotEmpty(errors);
        }
    }
}
