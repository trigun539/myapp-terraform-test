##########################
# SERVICES
##########################

resource "aws_ecs_service" "this" {
  provider    = aws.region-master
  name        = join("-", [var.appname, "service"])
  cluster     = aws_ecs_cluster.this.arn
  launch_type = var.launch_type

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  desired_count                      = var.tasks_count
  task_definition                    = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]
    subnets          = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = join("-", [var.appname, "task"])
    container_port   = var.app_port
  }
}
