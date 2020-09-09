##########################
# SERVICES
##########################

resource "aws_ecs_service" "this" {
  provider                           = aws.region-master
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.this.arn
  launch_type                        = var.launch_type
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  desired_count                      = var.tasks_count
  task_definition                    = aws_ecs_task_definition.this.arn

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = "${var.name}-task"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_target_group.this]
}
