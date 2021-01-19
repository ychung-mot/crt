using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.User
{
    public class UserDto
    {
        public UserDto()
        {
            UserRoleIds = new List<decimal>();
            UserRegionIds = new List<decimal>();
        }

        [JsonPropertyName("id")]
        public decimal SystemUserId { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsProjectMgr { get; set; }
        public virtual IList<decimal> UserRoleIds { get; set; }
        public virtual IList<decimal> UserRegionIds { get; set; }
    }
}