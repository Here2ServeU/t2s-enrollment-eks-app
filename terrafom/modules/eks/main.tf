module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id
  enable_irsa     = true
  tags = {
    Environment = var.environment
  }
}

