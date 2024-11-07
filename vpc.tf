# VPC
resource "aws_vpc" "three-tier-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "three-tier-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.vpc_azs[count.index % length(var.vpc_azs)]
  map_public_ip_on_launch = true

  tags = {
    Name = "three-tier-public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.vpc_azs[count.index % length(var.vpc_azs)]
  map_public_ip_on_launch = false

  tags = {
    Name = "three-tier-private-subnet-${count.index + 1}"
  }
}
