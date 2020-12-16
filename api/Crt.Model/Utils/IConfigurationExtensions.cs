using Microsoft.Extensions.Configuration;

namespace Crt.Model.Utils
{
    public static class IConfigurationExtensions
    {
        public static string GetEnvironment(this IConfiguration config)
        {
            var env = config.GetValue<string>("ASPNETCORE_ENVIRONMENT").ToUpperInvariant();

            switch (env)
            {
                case DotNetEnvironments.Prod:
                    return CrtEnvironments.Prod;
                case DotNetEnvironments.Dev:
                    return CrtEnvironments.Dev;
                case DotNetEnvironments.Test:
                    return CrtEnvironments.Test;
                case DotNetEnvironments.Uat:
                    return CrtEnvironments.Uat;
                case DotNetEnvironments.Train:
                    return CrtEnvironments.Train;
                default:
                    return CrtEnvironments.Unknown;
            }
        }
    }
}
