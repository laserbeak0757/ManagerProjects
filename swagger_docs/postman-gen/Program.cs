using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Nodes;

var repo = Path.Combine("c:\\", "Projects", "Proyectos", "sip-ms-diligencias");
var openApiPath = Path.Combine(repo, "docs", "openapi", "v1", "openapi.json");
var outRoot = Path.Combine("c:\\", "Projects", "swagger_docs");
Directory.CreateDirectory(outRoot);

var openApiJson = File.ReadAllText(openApiPath);
using var doc = JsonDocument.Parse(openApiJson);
var root = doc.RootElement;
var info = root.GetProperty("info");
var title = info.TryGetProperty("title", out var titleElem) ? titleElem.GetString() : "NEXO.Diligencias";

var servers = root.TryGetProperty("servers", out var serversElem) ? serversElem.EnumerateArray().ToList() : new List<JsonElement>();
var baseUrl = servers.Count > 0 && servers[0].TryGetProperty("url", out var urlEl) ? urlEl.GetString()?.TrimEnd('/') ?? "http://localhost:8088" : "http://localhost:8088";

var collection = new JsonObject
{
    ["info"] = new JsonObject
    {
        ["name"] = $"{title} - Postman",
        ["description"] = $"Coleccion de validacion derivada de OpenAPI para {title}.\n\nFuente oficial: docs/openapi/v1/openapi.json",
        ["schema"] = "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    ["item"] = new JsonArray(),
    ["variable"] = new JsonArray(
        new JsonObject { ["key"] = "baseUrl", ["value"] = baseUrl ?? "http://localhost:8088" },
        new JsonObject { ["key"] = "bearerToken", ["value"] = "" },
        new JsonObject { ["key"] = "tenantId", ["value"] = "1" }
    ),
    ["auth"] = new JsonObject
    {
        ["type"] = "bearer",
        ["bearer"] = new JsonArray(new JsonObject { ["key"] = "token", ["value"] = "{{bearerToken}}", ["type"] = "string" })
    }
};

var items = new JsonArray();

if (root.TryGetProperty("paths", out var pathsProp))
{
    foreach (var pathProp in pathsProp.EnumerateObject().OrderBy(p => p.Name))
    {
        var pathName = pathProp.Name;
        var pathItem = pathProp.Value;
        foreach (var methodProp in pathItem.EnumerateObject().OrderBy(p => p.Name))
        {
            var method = methodProp.Name.ToLowerInvariant();
            if (method is not "get" and not "post" and not "put" and not "patch" and not "delete" and not "head" and not "options")
            {
                continue;
            }

            var operation = methodProp.Value;
            var summary = operation.TryGetProperty("summary", out var summaryElem) && !string.IsNullOrWhiteSpace(summaryElem.GetString())
                ? summaryElem.GetString()!
                : (operation.TryGetProperty("description", out var descElem) && !string.IsNullOrWhiteSpace(descElem.GetString())
                    ? descElem.GetString()!
                    : $"{method.ToUpperInvariant()} {pathName}");

            var segments = new List<string>();
            foreach (var segment in pathName.Split('/', StringSplitOptions.RemoveEmptyEntries))
            {
                if (segment.StartsWith('{') && segment.EndsWith('}'))
                {
                    segments.Add("{{" + segment.Trim('{', '}') + "}}");
                }
                else
                {
                    segments.Add(segment);
                }
            }

            var rawUrl = "{{baseUrl}}/" + string.Join('/', segments);
            var request = new JsonObject
            {
                ["name"] = summary,
                ["request"] = new JsonObject
                {
                    ["method"] = method.ToUpperInvariant(),
                    ["header"] = new JsonArray(
                        new JsonObject { ["key"] = "Accept", ["value"] = "application/json" },
                        new JsonObject { ["key"] = "Content-Type", ["value"] = "application/json" }
                    ),
                    ["url"] = new JsonObject
                    {
                        ["raw"] = rawUrl,
                        ["host"] = new JsonArray("{{baseUrl}}"),
                        ["path"] = JsonValue.Create(segments)
                    },
                    ["auth"] = new JsonObject
                    {
                        ["type"] = "bearer",
                        ["bearer"] = new JsonArray(new JsonObject { ["key"] = "token", ["value"] = "{{bearerToken}}", ["type"] = "string" })
                    }
                },
                ["response"] = new JsonArray()
            };

            var queryParams = new JsonArray();
            if (operation.TryGetProperty("parameters", out var parametersProp))
            {
                foreach (var param in parametersProp.EnumerateArray())
                {
                    if (param.TryGetProperty("in", out var inProp) && inProp.GetString() == "query")
                    {
                        queryParams.Add(new JsonObject
                        {
                            ["key"] = param.GetProperty("name").GetString(),
                            ["value"] = "",
                            ["description"] = param.TryGetProperty("description", out var desc) ? desc.GetString() : ""
                        });
                    }
                }
            }
            if (queryParams.Count > 0)
            {
                request["request"]!["url"]!["query"] = queryParams;
            }

            if (operation.TryGetProperty("requestBody", out _))
            {
                request["request"]!["body"] = new JsonObject
                {
                    ["mode"] = "raw",
                    ["raw"] = "{\n  \"example\": \"replace-with-valid-payload\"\n}",
                    ["options"] = new JsonObject
                    {
                        ["raw"] = new JsonObject { ["language"] = "json" }
                    }
                };
            }

            items.Add(request);
        }
    }
}

collection["item"] = new JsonArray(new JsonObject { ["name"] = "Endpoints HTTP", ["item"] = items });

var options = new JsonSerializerOptions
{
    Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping,
    WriteIndented = true,
    TypeInfoResolver = new System.Text.Json.Serialization.Metadata.DefaultJsonTypeInfoResolver()
};

var outputPath = Path.Combine(outRoot, "sip-ms-diligencias.json");
var repoCollectionPath = Path.Combine(repo, "docs", "collections", "postman", "sip-ms-diligencias.postman_collection.json");
File.WriteAllText(outputPath, collection.ToJsonString(options));
File.WriteAllText(repoCollectionPath, collection.ToJsonString(options));

Console.WriteLine(outputPath);
Console.WriteLine(repoCollectionPath);
