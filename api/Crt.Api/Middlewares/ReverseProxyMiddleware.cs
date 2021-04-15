using Crt.Api.Extensions;
using Crt.HttpClients;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace Crt.Api.Middlewares
{
    public class ReverseProxyMiddleware
    {
        private static readonly HttpClient _httpClient = new HttpClient();
        private readonly RequestDelegate _nextMiddleware;
        private readonly string _ogsServer;

        public ReverseProxyMiddleware(RequestDelegate nextMiddleware, IConfiguration config)
        {
            _nextMiddleware = nextMiddleware;
            _ogsServer = config.GetValue<string>("ServiceAccount:OgsServer");

            var userId = config.GetValue<string>("ServiceAccount:User");
            var password = config.GetValue<string>("ServiceAccount:Password");

            _httpClient.Timeout = new TimeSpan(0, 0, 15);
            _httpClient.DefaultRequestHeaders.Clear();
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic",
                Convert.ToBase64String(Encoding.GetEncoding("ISO-8859-1").GetBytes($"{userId}:{password}")));
        }

        public async Task Invoke(HttpContext context)
        {
            var targetUri = BuildTargetUri(context.Request);

            if (targetUri != null)
            {
                Console.WriteLine($"Proxy - {_ogsServer} {targetUri}");

                var targetRequestMessage = CreateTargetMessage(context, targetUri);

                using (var responseMessage = await _httpClient.SendAsync(targetRequestMessage, HttpCompletionOption.ResponseHeadersRead, context.RequestAborted))
                {
                    if (responseMessage.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                    {
                        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                        context.Response.ContentType = "application/json";

                        var problem = new ValidationProblemDetails()
                        {
                            Type = "https://crt.bc.gov.ca/exception",
                            Title = $"Access denied from {targetUri}",
                            Status = StatusCodes.Status401Unauthorized,
                            Detail = "Authentication failed.",
                            Instance = context.Request.Path
                        };

                        await context.Response.WriteJsonAsync(problem, "application/problem+json");
                    }
                    else
                    {
                        context.Response.StatusCode = (int)responseMessage.StatusCode;
                        CopyFromTargetResponseHeaders(context, responseMessage);
                        await responseMessage.Content.CopyToAsync(context.Response.Body);
                    }
                }
                return;
            }
            await _nextMiddleware(context);
        }

        private HttpRequestMessage CreateTargetMessage(HttpContext context, Uri targetUri)
        {
            var requestMessage = new HttpRequestMessage();
            CopyFromOriginalRequestContentAndHeaders(context, requestMessage);

            requestMessage.RequestUri = targetUri;
            requestMessage.Headers.Host = targetUri.Host;
            requestMessage.Method = GetMethod(context.Request.Method);

            return requestMessage;
        }

        private void CopyFromOriginalRequestContentAndHeaders(HttpContext context, HttpRequestMessage requestMessage)
        {
            var requestMethod = context.Request.Method;

            if (!HttpMethods.IsGet(requestMethod) &&
              !HttpMethods.IsHead(requestMethod) &&
              !HttpMethods.IsDelete(requestMethod) &&
              !HttpMethods.IsTrace(requestMethod))
            {
                var streamContent = new StreamContent(context.Request.Body);
                requestMessage.Content = streamContent;
            }

            foreach (var header in context.Request.Headers)
            {
                requestMessage.Content?.Headers.TryAddWithoutValidation(header.Key, header.Value.ToArray());
            }
        }

        private static void CopyFromTargetResponseHeaders(HttpContext context, HttpResponseMessage responseMessage)
        {
            foreach (var header in responseMessage.Headers)
            {
                context.Response.Headers[header.Key] = header.Value.ToArray();
            }

            foreach (var header in responseMessage.Content.Headers)
            {
                context.Response.Headers[header.Key] = header.Value.ToArray();
            }
            context.Response.Headers.Remove("transfer-encoding");
        }

        private static HttpMethod GetMethod(string method)
        {
            if (HttpMethods.IsDelete(method)) return HttpMethod.Delete;
            if (HttpMethods.IsGet(method)) return HttpMethod.Get;
            if (HttpMethods.IsHead(method)) return HttpMethod.Head;
            if (HttpMethods.IsOptions(method)) return HttpMethod.Options;
            if (HttpMethods.IsPost(method)) return HttpMethod.Post;
            if (HttpMethods.IsPut(method)) return HttpMethod.Put;
            if (HttpMethods.IsTrace(method)) return HttpMethod.Trace;
            return new HttpMethod(method);
        }

        private Uri BuildTargetUri(HttpRequest request)
        {
            Uri targetUri = null;

            if (request.Path.StartsWithSegments("/ogs-internal", out var remainingPath))
            {
                targetUri = new Uri(_ogsServer + remainingPath + request.QueryString);
            }

            return targetUri;
        }
    }
}
