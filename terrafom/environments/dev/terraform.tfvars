vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
azs                 = ["us-east-1a", "us-east-1b"]
cluster_name        = "t2s-enrollment-cluster"
environment         = "dev"
s3_bucket_name      = "t2s-enrollment-tf-state"
dynamodb_table_name = "t2s-enrollment-tf-lock"
frontend_repo       = "t2s-frontend"
backend_repo        = "t2s-backend"

