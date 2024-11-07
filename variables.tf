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

variable "security_group_ids" {
  description     = "List of security group IDs to associate with RDS instances"
  type            = list(string)
}

variable "subnet_ids" {
  description     = "List of private subnet IDs for RDS instances"
  type            = list(string)
}