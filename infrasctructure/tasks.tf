##########################
# TASK DEFINITIONS
##########################

data "aws_caller_identity" "current" {
  provider = aws.region-master
}

resource "aws_ecs_task_definition" "this" {
  provider                 = aws.region-master
  family                   = "${var.name}-task-def"
  requires_compatibilities = [var.launch_type]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([{
    image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/myapp/nginx:latest"
    name      = "${var.name}-task"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.app_port
      hostPort      = var.app_port
    }]
  }])

  tags = {
    Name = "${var.name}-task-def"
  }
}
