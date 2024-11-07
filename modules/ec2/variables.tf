# modules/ec2/variables.tf

variable "instance_type" {
  description = "The type of instance to use for the EC2 server (e.g., t3.micro)"
  type        = string
}

variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EC2 instances will be deployed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}
