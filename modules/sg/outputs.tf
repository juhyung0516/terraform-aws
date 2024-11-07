output "external_lb_sg_id" {
  description = "Security Group ID for the external load balancer"
  value       = aws_security_group.external_lb.id
}

output "web_tier_sg_id" {
  description = "Security Group ID for the web tier"
  value       = aws_security_group.web_tier.id
}

output "internal_lb_sg_id" {
  description = "Security Group ID for the internal load balancer"
  value       = aws_security_group.internal_lb.id
}

output "app_tier_sg_id" {
  description = "Security Group ID for the application tier"
  value       = aws_security_group.app_tier.id
}

output "db_tier_sg_id" {
  description = "Security Group ID for the database tier"
  value       = aws_security_group.db_tier.id
}