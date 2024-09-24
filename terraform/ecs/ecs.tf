resource "aws_apprunner_service" "example" {
  service_name = "example"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repo}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu    = "1 vCPU"    # Adjust as needed
    memory = "2 GB"      # Adjust as needed
  }

  tags = {
    Name = "hello-world-app"
  }
}