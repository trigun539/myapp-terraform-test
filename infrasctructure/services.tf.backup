##########################
# SERVICES
##########################

resource "aws_ecs_service" "this" {
  provider                           = aws.region-master
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.this.arn
  launch_type                        = var.launch_type
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  desired_count                      = var.tasks_count
  task_definition                    = aws_ecs_task_definition.this.arn

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
