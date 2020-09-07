##########################
# LOAD BALANCER
##########################

# Create load balancer
resource "aws_lb" "this" {
  provider           = aws.region-master
  name               = join("-", [var.appname, "lb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = join("-", [var.appname, "lb"])
  }
}

# Creating load balancer target group
resource "aws_lb_target_group" "this" {
  provider    = aws.region-master
  name        = join("-", [var.appname, "lb-tg"])
  protocol    = "HTTP"
  port        = var.app_port
  target_type = "ip"
  vpc_id      = aws_vpc.this.id
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.app_port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = join("-", [var.appname, "lb-tg"])
  }
}


# Create the load balancer listener - http
resource "aws_lb_listener" "http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
