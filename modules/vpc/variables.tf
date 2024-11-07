variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
}

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
