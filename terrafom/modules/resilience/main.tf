resource "kubernetes_horizontal_pod_autoscaler" "frontend_hpa" {
  metadata {
    name = "frontend-hpa"
  }
  spec {
    scale_target_ref {
      kind       = "Deployment"
      name       = "frontend"
      api_version = "apps/v1"
    }
    min_replicas = 2
    max_replicas = 5
    target_cpu_utilization_percentage = 60
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "backend_hpa" {
  metadata {
    name = "backend-hpa"
  }
  spec {
    scale_target_ref {
      kind       = "Deployment"
      name       = "backend"
      api_version = "apps/v1"
    }
    min_replicas = 2
    max_replicas = 5
    target_cpu_utilization_percentage = 60
  }
}
