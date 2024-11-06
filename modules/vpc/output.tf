output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "db_subnet_ids" {
  value = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]
  description = "List of DB-tier subnet IDs for the RDS subnet group"
}
# modules/vpc/output.tf

output "db_subnet_a_id" {
  value       = aws_subnet.db_subnet_a.id
  description = "DB-tier subnet A ID"
}

output "db_subnet_b_id" {
  value       = aws_subnet.db_subnet_b.id
  description = "DB-tier subnet B ID"
}


output "vpc_flow_logs_log_group_arn" {
  value = aws_cloudwatch_log_group.vpc_flow_logs.arn
  description = "ARN of the CloudWatch Log Group for VPC Flow Logs"
}

output "vpc_flow_log_id" {
  value = aws_flow_log.vpc_flow_log.id
  description = "ID of the VPC Flow Log"
}
