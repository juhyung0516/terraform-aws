variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "project_name" {
  description = "The project name to use in resource names"
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
  description     = "The username for the database"
  type            = string
}

variable "db_password" {
  description     = "The password for the database"
  type            = string
}

variable "db_instance_class" {
  description     = "The instance class for RDS (e.g., db.t3.micro)"
  type            = string
}

variable "db_allocated_storage" {
  description     = "The allocated storage for the RDS instance in GB"
  type            = number
}

variable "db_engine" {
  description     = "The database engine to use (e.g., mysql, postgres)"
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

variable "subnet_ids" {
  description = "List of subnet IDs to deploy RDS instances in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with RDS instances"
  type        = list(string)
}