# modules/ec2/outputs.tf

output "private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = aws_instance.app_server[*].private_ip
}