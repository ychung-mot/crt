using Hangfire;
using Hangfire.Storage;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using System;
using System.Data.SqlClient;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace Crt.Hangfire
{
    public class HangfireHealthCheck : IHealthCheck
    {
        private string _connectionString;
        private IMonitoringApi _monitoringApi;

        public HangfireHealthCheck(string connectionString)
        {
            _connectionString = connectionString;
            _monitoringApi = JobStorage.Current.GetMonitoringApi();
        }

        public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
        {
            try
            {
                using var connection = new SqlConnection(_connectionString);

                await connection.OpenAsync(cancellationToken);

                var command = connection.CreateCommand();
                command.CommandText = "SELECT COUNT(*) FROM CRT_ROLE";
                var count = await command.ExecuteScalarAsync(cancellationToken);

                var stats = _monitoringApi.GetStatistics();
                var statsJson = JsonSerializer.Serialize(stats);

                return HealthCheckResult.Healthy(statsJson);
            }
            catch (Exception ex)
            {
                return new HealthCheckResult(context.Registration.FailureStatus, exception: ex);
            }
        }
    }
}
