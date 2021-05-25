using System.Text.Json.Serialization;

namespace Crt.Model.Dtos.Keycloak
{
    public class KeycloakTokenDto
    {
        [JsonPropertyName("access_token")]
        public string AccessToken { get; set; }
    }

}
