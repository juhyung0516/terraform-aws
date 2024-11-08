# root/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for the private application subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for the private database subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

# RDS용
variable "db_allocated_storage" {
  description = "The allocated storage for the RDS instance"
  type        = number
}

variable "db_engine" {
  description = "The database engine to use (e.g., mysql, postgres)"
  type        = string
}

variable "db_instance_class" {
  description = "The instance class for RDS (e.g., db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "The name of the primary database"
  type        = string
}

variable "db_backup_name" {
  description = "The name of the backup database"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description     = "The password for the database"
  type            = string
}

variable "db_parameter_group_name" {
  description     = "The DB parameter group name"
  type            = string
}

variable "multi_az" {
  description     = "Enable Multi-AZ deployment for RDS"
  type            = bool
}

variable "web_instance_type" {
  description = "Instance type for web servers"
}

variable "web_ami" {
  description = "AMI ID for web servers"
}

variable "app_instance_type" {
  description = "Instance type for app servers"
}

variable "app_ami" {
  description = "AMI ID for app servers"
}

# app_server_ami_id 변수에 임시 기본값 지정
variable "app_server_ami_id" {
  description = "The AMI ID for the App Server"
  type        = string
}

variable "app_server_ami_id" {
  description = "AMI ID for the App Server"
  default       = module.app_server[0].app_server_ami_id
}