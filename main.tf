provider "aws" {
  region = var.aws_region
}

# VPC 모듈 (3-Tier 아키텍처 중 하나)
module "vpc" {
  source = "./modules/vpc"
}

# Security Group 모듈 호출 - vpc 모듈의 VPC ID 출력값을 전달
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id  # vpc 모듈에서 출력된 vpc_id를 사용
}

# RDS 모듈 호출, VPC 모듈에서 출력된 DB 서브넷 ID를 전달
module "rds" {
  source = "./modules/rds"

  db_subnet_ids = [module.vpc.db_subnet_a_id, module.vpc.db_subnet_b_id]
  # 추가적인 RDS 설정 변수들
}

module "ec2" {
  source = "./modules/ec2"  # ASG 모듈 경로

  public_subnet_a = module.vpc.public_subnet_a_id  # 첫 번째 퍼블릭 서브넷 ID
  public_subnet_b = module.vpc.public_subnet_b_id  # 두 번째 퍼블릭 서브넷 ID
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