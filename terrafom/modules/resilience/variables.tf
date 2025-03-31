# terraform/modules/resilience/variables.tf

variable "frontend_hpa_config" {
  description = "Configuration for frontend HPA"
  type = object({
    name                               = string
    min_replicas                       = number
    max_replicas                       = number
    target_cpu_utilization_percentage = number
  })
  default = {
    name                               = "frontend"
    min_replicas                       = 2
    max_replicas                       = 5
    target_cpu_utilization_percentage = 60
  }
}

variable "backend_hpa_config" {
  description = "Configuration for backend HPA"
  type = object({
    name                               = string
    min_replicas                       = number
    max_replicas                       = number
    target_cpu_utilization_percentage = number
  })
  default = {
    name                               = "backend"
    min_replicas                       = 2
    max_replicas                       = 5
    target_cpu_utilization_percentage = 60
  }
}
