# modules/ec2/outputs.tf

output "private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = aws_instance.app_server[*].private_ip
}

# AMI ID를 출력하여 상위에서 참조할 수 있도록 설정
output "app_server_ami_ids" {
  description = "List of AMI IDs for App Server instances"
  value       = [for ami in aws_ami_from_instance.app_server_ami : ami.id]
}

# output "app_server_ami_id" {
#   description = "AMI ID for the App Server"
#   value       = aws_ami_from_instance.app_server_ami.id
# }

# output "web_server_id" {
#   description = "The ID of the Web Server instance"
#   value       = aws_instance.web_server.id
# }

# output "web_server_ami_id" {
#   description = "AMI ID for the Web Server"
#   value       = aws_ami_from_instance.web_server_ami.id
# }
