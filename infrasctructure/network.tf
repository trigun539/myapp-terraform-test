##########################
# VPCs
##########################

# Create VPC in us-east-1

resource "aws_vpc" "this" {
  provider             = aws.region-master
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = join("-", [var.appname, "vpc"])
  }
}

##########################
# IGW
##########################

# Create IGW in us-east-1
resource "aws_internet_gateway" "this" {
  provider = aws.region-master
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = join("-", [var.appname, "igw"])
  }
}

##########################
# SUBNETS
##########################

# Get all available Avialability Zones (AZ) for master region

data "aws_availability_zones" "this" {
  provider = aws.region-master
  state    = "available"
}

# Create subnet #1 in use-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.this.names, 0)
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.15.1.0/24"
  tags = {
    Name = join("-", [var.appname, "vpc-subnect-1"])
  }
}

# Create subnet #2 in use-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.this.names, 1)
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.15.2.0/24"
  tags = {
    Name = join("-", [var.appname, "vpc-subnect-2"])
  }
}

##########################
# ROUTING TABLES
##########################

# Create route table in us-east-1
resource "aws_route_table" "this" {
  provider = aws.region-master
  vpc_id   = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = join("-", [var.appname, "rt"])
  }
}

# Overwrite default route table of VPC (master) with our route table entries
resource "aws_main_route_table_association" "this" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.this.id
}
