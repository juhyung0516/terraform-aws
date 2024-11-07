# modules/rds/outputs.tf

output "rds_endpoint" {
  description = "Primary RDS endpoint address"
  value       = aws_db_instance.primary.endpoint
}

output "rds_port" {
  description = "Primary RDS instance port"
  value       = aws_db_instance.primary.port
}