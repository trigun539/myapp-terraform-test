##########################
# SECURITY GROUPS
##########################

# Create SG for only TCP/80, TCP/443 and outbound access
resource "aws_security_group" "this" {
  provider    = aws.region-master
  name        = "${var.name}-sg"
  description = "Allow ${var.app_port} traffic to VPC"
  vpc_id      = aws_vpc.this.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow ${var.app_port} from anywhere"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
