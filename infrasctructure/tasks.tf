##########################
# TASK DEFINITIONS
##########################

data "aws_caller_identity" "current" {
  provider = aws.region-master
}

resource "aws_ecs_task_definition" "this" {
  provider                 = aws.region-master
  family                   = join("-", [var.appname, "task-def"])
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  container_definitions    = <<DEFINITION
[
  {
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/myapp/nginx:latest",
    "name": "${join("-", [var.appname, "task"])}",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}
