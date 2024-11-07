# AWS 기본 설정
variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

# VPC와 서브넷 설정
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# 가용 영역 설정 (a와 c 영역만 사용)
variable "vpc_azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
}

# 서브넷 CIDR 블록을 배열로 정의
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for application subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

# 기타 NAT 및 Flow Logs 설정
variable "nat_eip_associate_with_private_ip" {
  description = "Whether to associate NAT EIP with a private IP"
  type        = bool
}

variable "log_retention_in_days" {
  description = "Retention period for CloudWatch logs"
  type        = number
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to log (ALL, ACCEPT, REJECT)"
  type        = string
}

variable "iam_policy_arn" {
  description = "ARN of the IAM policy for VPC Flow Logs"
  type        = string
}
