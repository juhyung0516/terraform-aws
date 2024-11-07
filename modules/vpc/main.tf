provider "aws" {
  region = var.aws_region
}

# 1.VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# 2. 인터넷 게이트웨이(IGW) 생성 - 퍼블릭 서브넷의 외부 인터넷 액세스를 위해 필요
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# 퍼블릭 서브넷 생성 (가용 영역 a와 c에서 생성)
resource "aws_subnet" "public_subnets" {
  for_each = zipmap(var.vpc_azs, var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
  }
}

# 애플리케이션 서브넷 생성 (가용 영역 a와 c에서 생성)
resource "aws_subnet" "app_subnets" {
  for_each = zipmap(var.vpc_azs, var.app_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "${var.vpc_name}-app-${each.key}"
  }
}

# 데이터베이스 서브넷 생성 (가용 영역 a와 c에서 생성)
resource "aws_subnet" "db_subnets" {
  for_each = zipmap(var.vpc_azs, var.db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "${var.vpc_name}-db-${each.key}"
  }
}

# # NAT 게이트웨이 생성 - 프라이빗 서브넷에서 외부로의 액세스가 필요할 때 사용
# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnets["${var.vpc_azs[0]}"].id  # 첫 번째 퍼블릭 서브넷에 NAT 게이트웨이 생성
#   tags = {
#     Name = "${var.vpc_name}-nat-gw"
#   }
# }

# # 퍼블릭 라우트 테이블 생성 - IGW를 통해 인터넷에 연결
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "${var.vpc_name}-public-rt"
#   }
# }

# # 퍼블릭 라우트 테이블에 IGW 연결
# resource "aws_route" "public_route" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }

# # 퍼블릭 서브넷과 퍼블릭 라우트 테이블 연결
# resource "aws_route_table_association" "public_rt_assoc" {
#   for_each     = aws_subnet.public_subnets
#   subnet_id    = each.value.id
#   route_table_id = aws_route_table.public_rt.id
# }

# # 프라이빗 라우트 테이블 생성 - NAT 게이트웨이를 통해 외부에 연결
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "${var.vpc_name}-private-rt"
#   }
# }

# # 프라이빗 라우트 테이블에 NAT 게이트웨이 연결
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
# }

# # 애플리케이션 및 DB 서브넷을 프라이빗 라우트 테이블에 연결
# resource "aws_route_table_association" "app_rt_assoc" {
#   for_each     = aws_subnet.app_subnets
#   subnet_id    = each.value.id
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_route_table_association" "db_rt_assoc" {
#   for_each     = aws_subnet.db_subnets
#   subnet_id    = each.value.id
#   route_table_id = aws_route_table.private_rt.id
# }