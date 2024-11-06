# rds/variables.tf

variable "db_subnet_ids" {
  description = "List of DB-tier subnet IDs for the RDS subnet group"
  type        = list(string)
}

variable "db_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_master_password" {
  description = "Master password for the database"
  type        = string
  default     = "Qwer1234!"
}
