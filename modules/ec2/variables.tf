# modules/ec2/variables.tf

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet ID for the EC2 instance"
  type        = list(string)
  default     = []
}

variable "security_group_id" {
  description = "List of security group IDs for the EC2 instance"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Username for RDS database"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "Password for RDS database"
  type        = string
  default     = ""
}

variable "rds_endpoint" {
  description = "RDS instance endpoint"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2 instances"
  type        = string
  default     = null
}

variable "app_server_private_ip" {
  description = "The private IP address of the App Server"
  type        = string
  default     = ""
}

variable "app_server_ids" {
  description = "The ID of the App Server instance"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "Availability zones for EC2 instances"
  type        = list(string)
  default     = []
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = ""
}
