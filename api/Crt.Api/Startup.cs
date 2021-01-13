using Crt.Api.Extensions;
using Crt.Chris;
using Crt.Data.Repositories;
using Crt.Domain.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace Crt.Api
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

            services.AddHttpContextAccessor();
            services.AddCrtAuthentication(Configuration);
            services.AddCrtDbContext(connectionString, _env.IsDevelopment());
            services.AddCors();
            services.AddCrtControllers();
            services.AddCrtAutoMapper();
            services.AddCrtApiVersioning();
            services.AddCrtTypes();
            services.AddCrtSwagger(_env);
            services.AddChrisHttpClient(Configuration);
            services.AddCrtHealthCheck(connectionString);
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env,
            IServiceScopeFactory serviceScopeFactory, ICodeLookupRepository codeLookupRepo, IFieldValidatorService validator)
        {
            if (env.IsDevelopment())
                app.UseDeveloperExceptionPage();            

            app.UseExceptionMiddleware();
            app.UseCrtHealthCheck();
            app.UseAuthorization();
            app.UseAuthentication();
            app.UseRouting();
            app.UseCrtEndpoints();
            app.UseCrtSwagger(env, Configuration.GetSection("Constants:SwaggerApiUrl").Value);

            validator.CodeLookup = codeLookupRepo.LoadCodeLookupCache();
        }
    }
}
