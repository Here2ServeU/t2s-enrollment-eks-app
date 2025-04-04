# terraform/environments/dev/main.tf

module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                  = var.azs
}

module "eks" {
  source       = "../../modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  environment  = var.environment
}

module "s3_backend" {
  source              = "../../modules/s3-backend"
  s3_bucket_name      = var.s3_bucket_name
  dynamodb_table_name = var.dynamodb_table_name
}

module "ecr" {
  source        = "../../modules/ecr"
  frontend_repo = var.frontend_repo
  backend_repo  = var.backend_repo
}

module "cicd" {
  source = "../../modules/cicd"
}

module "security" {
  source = "../../modules/security"
}

module "monitoring" {
  source           = "../../modules/monitoring"
  datadog_api_key  = var.datadog_api_key
}

module "resilience" {
  source              = "../../modules/resilience"
  frontend_hpa_config = var.frontend_hpa_config
  backend_hpa_config  = var.backend_hpa_config
}
