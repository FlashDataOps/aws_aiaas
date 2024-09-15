resource "aws_ecs_cluster" "main" {
  name = "my-ecs-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

resource "aws_ecs_task_definition" "hello_world_task" {
  family                   = "hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "hello-world"
    image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.aws_ecr_repo}:latest"
    cpu       = 256
    memory    = 512
    essential = true
    # command   = ["python", "HelloWorld.py"] # Adjust to run your Python application
  }])
}

resource "aws_ecs_task" "hello_world_task_run" {
  task_definition = aws_ecs_task_definition.hello_world_task.arn
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = var.subnet_ids
#     security_groups = [var.security_group_id]
#     assign_public_ip = true
#   }

  depends_on = [aws_ecs_task_definition.hello_world_task]
}

resource "aws_ecr_repository" "hello_world" {
  name = "hello-world"
}