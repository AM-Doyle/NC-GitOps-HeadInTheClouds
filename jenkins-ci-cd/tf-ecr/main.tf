resource "aws_ecrpublic_repository" "frontend" {
  repository_name = var.ecr_frontend_repo_name
  force_destroy   = true
  tags = {
    env = "HITC ECR Repo For Frontend."
  }
}
resource "aws_ecrpublic_repository" "backend" {
  repository_name = var.ecr_backend_repo_name
  force_destroy   = true
  tags = {
    env = "HITC ECR Repo For Backend."
  }
}
