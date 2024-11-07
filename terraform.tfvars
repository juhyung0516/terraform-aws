# root/terraform.tfvars

aws_region       = "ap-northeast-2"
project_name     = "my-3tier-project"
vpc_cidr         = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
private_app_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]
private_db_subnet_cidrs = [
  "10.0.5.0/24",
  "10.0.6.0/24"
]
availability_zones = [
  "ap-northeast-2a",
  "ap-northeast-2c"
]