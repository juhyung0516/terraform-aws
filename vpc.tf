# 1. VPC 생성 
resource "aws_vpc" "three-tier-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
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

# 4. 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "three-tier-igw" {
  tags = {
    Name = "three-tier-igw"
  }
  vpc_id = aws_vpc.three-tier-vpc.id
}

# 5. NAT Gateway 생성
resource "aws_eip" "three-tier-nat-eip" {
  associate_with_private_ip = true
}

resource "aws_nat_gateway" "three-tier-natgw-01" {
  allocation_id = aws_eip.three-tier-nat-eip.id
  subnet_id     = aws_subnet.three-tier-pub-sub-1.id

  tags = {
    Name = "three-tier-natgw-01"
  }
  depends_on = [aws_internet_gateway.three-tier-igw]
}

# 6. RT 생성
# Web Route Table
resource "aws_route_table" "three-tier-web-rt" {
  vpc_id = aws_vpc.three-tier-vpc.id
  tags = {
    Name = var.web_route_table_name
  }
  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_internet_gateway.three-tier-igw.id
  }
}

# App Route Table
resource "aws_route_table" "three-tier-app-rt" {
  vpc_id = aws_vpc.three-tier-vpc.id
  tags = {
    Name = var.app_route_table_name
  }
  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_nat_gateway.three-tier-natgw-01.id
  }
}


# 7. RT 연결
resource "aws_route_table_association" "public_rt_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.three-tier-web-rt.id
}

resource "aws_route_table_association" "private_rt_associations" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.three-tier-app-rt.id
}

