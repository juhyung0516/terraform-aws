# root/main.tf

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  aws_region               = var.aws_region
  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  availability_zones       = var.availability_zones
}

module "sg" {
  source = "./modules/sg"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id  # VPC 모듈에서 vpc_id를 가져온다고 가정
}

# RDS 모듈 호출
module "rds" {
  source = "./modules/rds"

  # VPC에서 가져온 private DB 서브넷 IDs
  subnet_ids = module.vpc.private_db_subnet_ids

  # SG에서 가져온 DB 보안 그룹 ID
  security_group_ids = [module.sg.db_tier_sg_id]

  # RDS 관련 변수들 (variables.tf 및 tfvars에서 정의)
  project_name             = var.project_name
  aws_region              = var.aws_region
  db_name             = var.db_name
  db_backup_name      = var.db_backup_name
  db_username         = var.db_username
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  db_allocated_storage= var.db_allocated_storage
  db_engine           = var.db_engine
  db_parameter_group_name = var.db_parameter_group_name
  multi_az            = var.multi_az
}