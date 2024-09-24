resource "aws_apprunner_service" "example" {
  service_name = "montybot"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.access_role.arn
    }
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "${aws_ecr_repository.example.repository_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu    = "1 vCPU"
    memory = "2 GB"
  }

  tags = {
    Name = "hello-world-app"
  }
}

# IAM role for App Runner to access ECR
resource "aws_iam_role" "ecr_access_role" {
  name = "AppRunnerECRAccessRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "ecr_access_policy" {
  role = aws_iam_role.ecr_access_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:DescribeImages",
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}