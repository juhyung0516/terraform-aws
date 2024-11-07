# main.tf
provider "aws" {
  region = var.aws_region
}

# VPC 모듈 호출
module "vpc" {
  source = "./modules/vpc"

  # root 디렉토리의 변수를 modules/vpc 모듈로 전달
  aws_region         = var.aws_region
  vpc_name           = var.vpc_name
  vpc_cidr_block     = var.vpc_cidr_block
  vpc_azs            = var.vpc_azs
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs   = var.app_subnet_cidrs
  db_subnet_cidrs    = var.db_subnet_cidrs
  nat_eip_associate_with_private_ip = var.nat_eip_associate_with_private_ip
  log_retention_in_days = var.log_retention_in_days
  flow_log_traffic_type = var.flow_log_traffic_type
  iam_policy_arn      = var.iam_policy_arn
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