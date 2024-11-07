# modules/ec2/variables.tf

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the EC2 instance"
  type        = list(string)
}

variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
}

variable "db_username" {
  description = "Username for RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for RDS database"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS instance endpoint"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2 instances"
  type        = string
}

variable "app_server_private_ip" {
  description = "The private IP address of the App Server"
  type        = string
}


variable "availability_zone" {
  description = "availability zone"
  type        = string
}