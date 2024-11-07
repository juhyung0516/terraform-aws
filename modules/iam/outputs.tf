# modules/iam/outputs.tf

output "iam_instance_profile" {
  description = "IAM instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}
