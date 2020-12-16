using Hangfire;
using Crt.Api.Extensions;
using Crt.Chris;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Hosting;

namespace Crt.Hangfire
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        private IWebHostEnvironment _env;

        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            _env = env;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            var connectionString = Configuration.GetValue<string>("ConnectionStrings:CRT");
            var runHangfireServer = Configuration.GetValue<bool>("Hangfire:EnableServer");
            var workerCount = Configuration.GetValue<int>("Hangfire:WorkerCount");

            services.AddHttpContextAccessor();
            services.AddCrtDbContext(connectionString, _env.IsDevelopment());
            services.AddCrtAutoMapper();
            services.AddCrtTypes();
            services.AddChrisHttpClient(Configuration);
            services.AddCrtHangfire(connectionString, runHangfireServer, workerCount);
            services.AddHealthChecks().AddTypeActivatedCheck<HangfireHealthCheck>("Hangfire", HealthStatus.Unhealthy, connectionString);
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env,
            IServiceScopeFactory serviceScopeFactory, ICodeLookupRepository codeLookupRepo, IFieldValidatorService validator)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseExceptionMiddleware();
            app.UseCrtHealthCheck();
            app.UseHangfireDashboard();
        }
    }
}
