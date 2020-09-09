# Add LB DNS name
output "LB-DNS-NAME" {
  value = aws_lb.this.dns_name
}

