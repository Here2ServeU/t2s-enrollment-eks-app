variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "cluster_name" {
  default = "t2s-enrollment-cluster"
}

variable "environment" {
  default = "dev"
}

variable "s3_bucket_name" {
  default = "t2s-enrollment-tf-state"
}

variable "dynamodb_table_name" {
  default = "t2s-enrollment-tf-lock"
}

variable "frontend_repo" {
  default = "t2s-frontend"
}

variable "backend_repo" {
  default = "t2s-backend"
}

variable "datadog_api_key" {
  description = "Datadog API Key for monitoring"
  type        = string
}

variable "frontend_hpa_config" {
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


