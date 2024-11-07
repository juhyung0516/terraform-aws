# 1. VPC 생성 
resource "aws_vpc" "three-tier-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "three-tier-vpc"
  }
}

# 2. 퍼블릭 서브넷 생성
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

# 3. 프라이빗 서브넷 생성 
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

# Internet Gateway
resource "aws_internet_gateway" "three-tier-igw" {
  tags = {
    Name = "three-tier-igw"
  }
  vpc_id = aws_vpc.three-tier-vpc.id
}