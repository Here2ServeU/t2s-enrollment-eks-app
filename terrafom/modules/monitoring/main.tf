resource "helm_release" "datadog" {
  name       = "datadog-agent"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  namespace  = "default"

  set {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }

  set {
    name  = "datadog.site"
    value = "datadoghq.com"
  }

  set {
    name  = "agents.containerLogs.enabled"
    value = true
  }
}

