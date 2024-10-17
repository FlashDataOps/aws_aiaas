# Create an S3 bucket for Beanstalk app versions (optional)
resource "aws_s3_bucket" "beanstalk_bucket" {
  bucket = "beanstalk-app-version-bucket"
}