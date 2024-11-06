provider "aws" {
  region = var.aws_region
}

# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# 인터넷 게이트웨이(IGW) 생성 - 퍼블릭 서브넷의 외부 인터넷 액세스를 위해 필요
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# 퍼블릭 서브넷 생성 (웹 서버용)
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-b"
  }
}

# 애플리케이션 서버용 프라이빗 서브넷 생성
resource "aws_subnet" "app_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.vpc_name}-app-a"
  }
}

resource "aws_subnet" "app_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.vpc_name}-app-b"
  }
}

# 데이터베이스 서버용 프라이빗 서브넷 생성
resource "aws_subnet" "db_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.vpc_name}-db-a"
  }
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.vpc_name}-db-b"
  }
}

# NAT 게이트웨이 생성 - 프라이빗 서브넷에서 외부로의 액세스가 필요할 때 사용
resource "aws_eip" "nat_eip" {
  associate_with_private_ip = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
}

# 퍼블릭 라우트 테이블 생성 - IGW를 통해 인터넷에 연결
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# 퍼블릭 라우트 테이블에 IGW 연결
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# 퍼블릭 서브넷과 퍼블릭 라우트 테이블 연결
resource "aws_route_table_association" "public_rt_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

# 프라이빗 라우트 테이블 생성 - NAT 게이트웨이를 통해 외부에 연결
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# 프라이빗 라우트 테이블에 NAT 게이트웨이 연결
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# 애플리케이션 및 DB 서브넷을 프라이빗 라우트 테이블에 연결
resource "aws_route_table_association" "app_rt_assoc_a" {
  subnet_id      = aws_subnet.app_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "app_rt_assoc_b" {
  subnet_id      = aws_subnet.app_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_rt_assoc_a" {
  subnet_id      = aws_subnet.db_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_rt_assoc_b" {
  subnet_id      = aws_subnet.db_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}

# S3를 위한 게이트웨이 엔드포인트 설정 - VPC 내에서 S3에 직접 연결
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [
    aws_route_table.public_rt.id,
    aws_route_table.private_rt.id
  ]
  tags = {
    Name = "${var.vpc_name}-s3-endpoint"
  }
}

# 네트워크 ACL (NACL) 설정 - 기본 프라이빗 네트워크 정책
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-nacl"
  }
}

# NACL 인바운드 규칙 - 허용 규칙 예시 (포트 범위 및 CIDR에 맞춰 설정 가능)
resource "aws_network_acl_rule" "private_nacl_inbound" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# NACL 아웃바운드 규칙
resource "aws_network_acl_rule" "private_nacl_outbound" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# CloudWatch Log Group 생성 - VPC Flow Logs가 기록될 장소
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs/${var.vpc_name}"
  retention_in_days = 7 # 로그 보관 기간 (필요에 따라 조정 가능)
  tags = {
    Name = "${var.vpc_name}-flow-logs"
  }
}

# IAM Role 생성 - VPC Flow Logs가 CloudWatch로 로그를 전송하기 위해 필요
resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy Attachment - VPC Flow Logs의 CloudWatch 전송을 허용
resource "aws_iam_role_policy_attachment" "vpc_flow_logs_policy" {
  role       = aws_iam_role.vpc_flow_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"  # 올바른 ARN으로 수정
}

# VPC Flow Logs 설정
resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type         = "ALL" # "ALL", "ACCEPT", "REJECT" 중 선택 가능
  vpc_id               = aws_vpc.main.id
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
  tags = {
    Name = "${var.vpc_name}-flow-log"
  }
}
