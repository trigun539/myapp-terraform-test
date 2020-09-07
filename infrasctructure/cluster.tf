##########################
# ECS CLUSTER
##########################

# Creates ECS Cluster
resource "aws_ecs_cluster" "this" {
  provider = aws.region-master
  name     = "${var.name}-cluster"
}
