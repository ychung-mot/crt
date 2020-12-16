using System;

namespace Crt.Model
{
    public class AdAccount
    {
        public string Username { get; set; }
        public Guid UserGuid { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string DisplayName { get; set; }
    }
}
