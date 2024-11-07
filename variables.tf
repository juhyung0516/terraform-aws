# AWS 기본 설정
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default = "ap-northeast-2"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "three-tier-vpc"
}

# VPC CIDR
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# 가용 영역 설정 (a와 c 영역만 사용)
variable "vpc_azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

# Public Subnets CIDR Blocks
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/28", "10.0.0.16/28"]
}

# Private Subnets CIDR Blocks
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.0.32/28", "10.0.0.48/28", "10.0.0.64/28", "10.0.0.80/28"]
}

