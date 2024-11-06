variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "test3-vpc"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

# VPC Flow Logs에 대한 로그 보존 기간
variable "flow_logs_retention_days" {
  description = "Retention period for CloudWatch logs in days"
  type        = number
  default     = 7
}
