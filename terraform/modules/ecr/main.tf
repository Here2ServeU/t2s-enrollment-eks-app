resource "aws_ecr_repository" "frontend_repo" {
  name = var.frontend_repo
}

resource "aws_ecr_repository" "backend_repo" {
  name = var.backend_repo
}