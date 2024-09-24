resource "aws_ecr_repository" "hello_world" {
  name                 = "hello-world"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    ignore_changes = [image_tag_mutability, image_scanning_configuration]
    prevent_destroy = true  # Prevent accidental deletion of the repository
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.hello_world.repository_url
}