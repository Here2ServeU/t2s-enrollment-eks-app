resource "kubernetes_horizontal_pod_autoscaler" "frontend_hpa" {
  metadata {
    name = "${var.frontend_hpa_config.name}-hpa"
  }
  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = var.frontend_hpa_config.name
      api_version = "apps/v1"
    }
    min_replicas                         = var.frontend_hpa_config.min_replicas
    max_replicas                         = var.frontend_hpa_config.max_replicas
    target_cpu_utilization_percentage   = var.frontend_hpa_config.target_cpu_utilization_percentage
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "backend_hpa" {
  metadata {
    name = "${var.backend_hpa_config.name}-hpa"
  }
  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = var.backend_hpa_config.name
      api_version = "apps/v1"
    }
    min_replicas                         = var.backend_hpa_config.min_replicas
    max_replicas                         = var.backend_hpa_config.max_replicas
    target_cpu_utilization_percentage   = var.backend_hpa_config.target_cpu_utilization_percentage
  }
}
