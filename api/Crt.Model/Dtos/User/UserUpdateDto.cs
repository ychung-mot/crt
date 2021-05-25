using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.User
{
    public class UserUpdateDto : IUserSaveDto
    {
        public UserUpdateDto()
        {
            UserRoleIds = new List<decimal>();
        }

        [JsonPropertyName("id")]
        public decimal SystemUserId { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsProjectMgr { get; set; }

        public IList<decimal> UserRoleIds { get; set; }
        public IList<decimal> UserRegionIds { get; set; }
    }
}
