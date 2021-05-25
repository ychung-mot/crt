using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.User
{
    public class UserManagerDto
    {
        [JsonPropertyName("id")]
        public decimal SystemUserId { get; set; }
        public string Name { get => $"{FirstName} {LastName}"; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
