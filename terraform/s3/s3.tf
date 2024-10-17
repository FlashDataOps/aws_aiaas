# Create an S3 bucket for Beanstalk app versions (optional)
resource "aws_s3_bucket" "beanstalk_bucket" {
  bucket = var.s3_bucket_name
}

# Allow public access to the bucket
resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket = aws_s3_bucket.beanstalk_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.beanstalk_bucket.arn}/*"
      }
    ]
  })
}