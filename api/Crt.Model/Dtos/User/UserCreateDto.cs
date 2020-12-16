using System;
using System.Collections.Generic;

namespace Crt.Model.Dtos.User
{
    public class UserCreateDto : IUserSaveDto
    {
        public UserCreateDto()
        {
            UserRoleIds = new List<decimal>();
        }

        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public DateTime? EndDate { get; set; }

        public IList<decimal> UserRoleIds { get; set; }
    }
}
