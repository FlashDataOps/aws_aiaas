# Create an S3 bucket for Beanstalk app versions (optional)
resource "aws_s3_bucket" "beanstalk_bucket" {
  bucket = "beanstalk-app-version-bucket"
}

# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "montybot" {
  name        = "MontyBotApp"
  description = "Streamlit chatbot hosted on Elastic Beanstalk"
}

# Create IAM Role for Elastic Beanstalk
resource "aws_iam_role" "beanstalk_role" {
  name = "elastic-beanstalk-service-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "elasticbeanstalk.amazonaws.com" }
    }]
  })
}

# Attach a policy to allow Elastic Beanstalk to interact with other AWS resources
resource "aws_iam_role_policy_attachment" "beanstalk_policy" {
  role       = aws_iam_role.beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

# Define the Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "montybot_env" {
  name                = "MontyBotEnv"
  application         = aws_elastic_beanstalk_application.montybot.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.10 running Docker"

  setting {
    namespace = "aws:elasticbeanstalk:container:docker"
    name      = "Image"
    value     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.aws_ecr_repo}:latest"
  }

  # Optional environment variables or scaling settings
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "8080"
  }

  depends_on = [aws_elastic_beanstalk_application.montybot]
}

# IAM Role for Elastic Beanstalk to access ECR
resource "aws_iam_role_policy" "ecr_access" {
  role = aws_iam_role.beanstalk_role.id

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