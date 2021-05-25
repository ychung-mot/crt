using Crt.Model.Dtos.User;
using System;

namespace Crt.Model
{
    public class CrtCurrentUser
    {
        public Guid UserGuid { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string ApiClientId { get; set; }
        public UserCurrentDto UserInfo { get; set; }
    }
}
