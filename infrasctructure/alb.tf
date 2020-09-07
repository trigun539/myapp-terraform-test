##########################
# LOAD BALANCER
##########################

# Create load balancer
resource "aws_lb" "this" {
  provider           = aws.region-master
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = "${var.name}-lb"
  }
}

# Creating load balancer target group
resource "aws_alb_target_group" "this" {
  provider    = aws.region-master
  name        = "${var.name}-lb-tg"
  port        = var.app_port
  target_type = "ip"
  vpc_id      = aws_vpc.this.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.app_port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "${var.name}-lb-tg"
  }
  depends_on = [aws_lb.this]
}

# Create the load balancer listener - http
resource "aws_lb_listener" "this" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}
