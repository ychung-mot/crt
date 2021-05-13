using Microsoft.Extensions.DependencyInjection;
using System;
using System.Text;
using Microsoft.Extensions.Configuration;
using System.Net.Http.Headers;
using Crt.Model.Utils;

namespace Crt.HttpClients
{
    public static class HttpClientsServiceCollectionExtensions
    {
        public static void AddHttpClients(this IServiceCollection services, IConfiguration config)
        {
            services.AddHttpClient<IRouterApi, RouterApi>(client =>
            {
                client.BaseAddress = new Uri(config.GetValue<string>("Router:Url"));
                client.Timeout = new TimeSpan(0, 1, 30);
                client.DefaultRequestHeaders.Clear();
            });

            services.AddHttpClient<IGeoServerApi, GeoServerApi>(client =>
            {
                var env = config.GetEnvironment();
                client.BaseAddress = new Uri(config.GetValue<string>($"GeoServer{env}:Url"));
                client.Timeout = new TimeSpan(0, 0, config.GetValue<int>($"GeoServer{env}:Timeout"));
                client.DefaultRequestHeaders.Clear();

                var userId = config.GetValue<string>("ServiceAccount:User");
                var password = config.GetValue<string>("ServiceAccount:Password");
                var basicAuth = Convert.ToBase64String(Encoding.GetEncoding("ISO-8859-1").GetBytes($"{userId}:{password}"));
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", basicAuth);
            });

            services.AddHttpClient<IDataBCApi, DataBCApi>(client =>
            {
                client.BaseAddress = new Uri(config.GetValue<string>("DataBC:Url"));
                client.Timeout = new TimeSpan(0, 0, config.GetValue<int>("DataBC:Timeout"));
                client.DefaultRequestHeaders.Clear();
            });

            services.AddScoped<IApi, Api>();
        }
    }
}
