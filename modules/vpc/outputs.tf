# modules/vpc/outputs.tf
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS and ASG instances"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "List of private subnet IDs for the RDS instances"
  value       = aws_subnet.private_db[*].id
}
