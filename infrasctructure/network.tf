##########################
# VPCs
##########################

resource "aws_vpc" "this" {
  provider             = aws.region-master
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

##########################
# IGW
##########################

resource "aws_internet_gateway" "this" {
  provider = aws.region-master
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.name}-igw"
  }
}

##########################
# EIP
##########################

resource "aws_eip" "this" {
  count    = length(var.private_subnets)
  provider = aws.region-master
  vpc      = true

  tags = {
    Name = "${var.name}-eip-${count.index + 1}"
  }
}

##########################
# NAT GATEWAY
##########################

resource "aws_nat_gateway" "this" {
  count         = length(var.private_subnets)
  provider      = aws.region-master
  allocation_id = element(aws_eip.this.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags = {
    Name = "${var.name}-ngw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.this]
}


##########################
# SUBNETS
##########################

# Get all available Avialability Zones (AZ) for region
data "aws_availability_zones" "this" {
  provider = aws.region-master
  state    = "available"
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  provider          = aws.region-master
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(data.aws_availability_zones.this.names, count.index)

  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  provider                = aws.region-master
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(data.aws_availability_zones.this.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

##########################
# ROUTING TABLES
##########################

# PUBLIC

resource "aws_route_table" "public" {
  provider = aws.region-master
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route" "public" {
  provider               = aws.region-master
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*])
  provider       = aws.region-master
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

# PRIVATE

resource "aws_route_table" "private" {
  count    = length(aws_subnet.private[*])
  provider = aws.region-master
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.name}-private-rt-${count.index + 1}"
  }
}

resource "aws_route" "private" {
  count                  = length(aws_subnet.private[*])
  provider               = aws.region-master
  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[*])
  provider       = aws.region-master
  route_table_id = element(aws_route_table.private[*].id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
