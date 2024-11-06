provider "aws" {
  region = var.aws_region
}

# VPC 모듈 (3-Tier 아키텍처 중 하나)
module "vpc" {
  source = "./modules/vpc"
  vpc_name = "test2-vpc"
}

# EC2 모듈 (3-Tier 아키텍처 중 하나)
# module "ec2" {
#   source = "./modules/ec2"
#   instance_name = "test-ec2"
# }
# 
# # RDS 모듈 (3-Tier 아키텍처 중 하나)
# module "rds" {
#   source = "./modules/rds"
#   db_instance_name = "test-rds"
# }
# 
# # ALB 모듈 (3-Tier 아키텍처 중 하나)
# module "alb" {
#   source = "./modules/alb"
#   alb_name = "test-alb"
# }
# 
# # CloudTrail 모듈
# module "cloudtrail" {
#   source = "./modules/cloudtrail"
#   trail_name = "test-cloudtrail"
# }
# 
# # CloudWatch 모듈
# module "cloudwatch" {
#   source = "./modules/cloudwatch"
#   log_group_name = "test-cloudwatch"
# }
# 
# # GuardDuty 모듈
# module "guardduty" {
#   source = "./modules/guardduty"
#   detector_name = "test-guardduty"
# }
# 
# # Config 모듈
# module "config" {
#   source = "./modules/config"
#   config_recorder_name = "test-config"
# }
# 