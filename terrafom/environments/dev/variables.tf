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


