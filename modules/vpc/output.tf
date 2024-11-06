output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "vpc_flow_logs_log_group_arn" {
  value = aws_cloudwatch_log_group.vpc_flow_logs.arn
  description = "ARN of the CloudWatch Log Group for VPC Flow Logs"
}

output "vpc_flow_log_id" {
  value = aws_flow_log.vpc_flow_log.id
  description = "ID of the VPC Flow Log"
}
