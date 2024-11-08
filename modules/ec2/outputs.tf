# modules/ec2/outputs.tf

output "private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = aws_instance.app_server[*].private_ip
}

output "app_server_ids" {
  description = "The IDs of the App Server instances"
  value       = [for instance in aws_instance.app_server : instance.id]
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
