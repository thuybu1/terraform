# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs = var.azs

  enable_dhcp_options = true
  enable_dns_hostnames = true

  tags = var.common_tags
}

# Subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = module.vpc.azs[count.index]

  tags = merge(
    {
      Name = "Public Subnet ${count.index + 1}"
    },
    var.common_tags)
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)

  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = module.vpc.azs[count.index]

  tags = merge(
    {
      Name = "Private Subnet ${count.index + 1}"
      Terraform   = "true"
    },
    var.common_tags)
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    {
      Name = "${var.vpc_name} Internet Gateway"
    },
    var.common_tags)
}

# Elastic IP
resource "aws_eip" "eip" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Route Tables
# Public
resource "aws_route_table" "public_rt" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    {
      Name = "Public Route Table"
    },
    var.common_tags)
}

resource "aws_route" "route-to-internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "puclic_rt_asso" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Private
resource "aws_route_table" "private_rt" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    {
      Name = "Private Route Table"
    },
    var.common_tags)
}

resource "aws_route" "route-to-nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "private_rt_asso" {
  count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}