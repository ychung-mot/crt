using Crt.Model;
using Novell.Directory.Ldap;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.Net.Security;

namespace Crt.Domain.Services
{
    public interface ILdapService
    {
        AdAccount LdapSearch(string filterAttr, string value);
    }

    public class LdapService : ILdapService
    {
        private string _userId;
        private string _password;
        private string _server;
        private int _port;

        public LdapService(IConfiguration config)
        {
            _userId = config.GetValue<string>("ServiceAccount:User");
            _password = config.GetValue<string>("ServiceAccount:Password");
            _server = config.GetValue<string>("ServiceAccount:Server");
            _port = config.GetValue<int>("ServiceAccount:Port");
        }
        public AdAccount LdapSearch(string filterAttr, string value)
        {
            using var conn = new LdapConnection() { SecureSocketLayer = false };
            conn.Connect(_server, _port);

            conn.UserDefinedServerCertValidationDelegate += (sender, certificate, chain, sslPolicyErrors) =>
            {
                if (sslPolicyErrors == SslPolicyErrors.None)
                    return true;

                if (chain.ChainElements == null)
                    return false;

                return true;
            };

            conn.StartTls();

            conn.Bind(@$"IDIR\{_userId}", _password);

            var filter = $"(&(objectCategory=person)(objectClass=user)({filterAttr}={value}))";
            var search = conn.Search("OU=BCGOV,DC=idir,DC=BCGOV", LdapConnection.ScopeSub, filter, new string[] { "sAMAccountName", "bcgovGUID", "givenName", "sn", "mail", "displayName" }, false);

            var entry = search.FirstOrDefault();

            if (entry == null)
                return null;

            return new AdAccount
            {
                Username = entry.GetAttribute("sAMAccountName").StringValue,
                UserGuid = new Guid(entry.GetAttribute("bcgovGUID").StringValue),
                FirstName = entry.GetAttribute("givenName").StringValue,
                LastName = entry.GetAttribute("sn").StringValue,
                Email = entry.GetAttributeSet().Any(x => x.Key == "mail") ? entry.GetAttribute("mail").StringValue : "",
                DisplayName = entry.GetAttribute("displayName").StringValue
            };
        }
    }
}
