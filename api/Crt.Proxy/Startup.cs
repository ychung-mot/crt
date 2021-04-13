using Crt.Api.Extensions;
using Crt.HttpClients;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.Net;
using System.Net.Http;
using System.Net.Security;
using Yarp.ReverseProxy.Service.Proxy;

namespace Crt.Proxy
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        private IWebHostEnvironment _env;
        private HttpMessageInvoker _httpClient;
        private string _ogsServer;
        private RequestProxyOptions _proxyOptions;

        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            _env = env;
            _httpClient = GetClientForInternalOgs();
            _ogsServer = Configuration.GetValue<string>("ServiceAccount:OgsServer");
            _proxyOptions = new RequestProxyOptions { Timeout = TimeSpan.FromSeconds(100) };
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            var connectionString = Configuration.GetValue<string>("ConnectionStrings:CRT");

            services.AddHttpContextAccessor();
            services.AddCrtAuthentication(Configuration);
            services.AddCrtDbContext(connectionString, _env.IsDevelopment());
            services.AddCrtAutoMapper();
            services.AddCrtTypes();
            services.AddHttpClients(Configuration);
            services.AddReverseProxy();
            services.AddHttpProxy();
            services.AddCrtHealthCheck(connectionString);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IHttpProxy httpProxy)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseExceptionMiddleware();
            app.UseCrtHealthCheck();
            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.Map("/{**catch-all}", async httpContext =>
                {
                    await httpProxy.ProxyAsync(httpContext,
                        _ogsServer,
                        _httpClient,
                        _proxyOptions,
                        HttpTransformer.Default);

                    var errorFeature = httpContext.Features.Get<IProxyErrorFeature>();
                    if (errorFeature != null)
                    {
                        var error = errorFeature.Error;
                        var exception = errorFeature.Exception;
                    }
                }).RequireAuthorization();
            });
        }

        private HttpMessageInvoker GetClientForInternalOgs()
        {
            var userId = Configuration.GetValue<string>("ServiceAccount:User");
            var password = Configuration.GetValue<string>("ServiceAccount:Password");

            var httpClient = new HttpMessageInvoker(new SocketsHttpHandler()
            {
                UseProxy = false,
                AllowAutoRedirect = false,
                AutomaticDecompression = DecompressionMethods.None,
                UseCookies = false,
                PreAuthenticate = true,
                Credentials = new NetworkCredential(userId, password),
                SslOptions = new SslClientAuthenticationOptions
                {
                    RemoteCertificateValidationCallback = delegate { return true; },
                }
            });
            return httpClient;
        }
    }
}
