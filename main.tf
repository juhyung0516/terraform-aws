# root/main.tf

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
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

# 앱 서버 생성 AMI용
module "app_server" {
  source              = "./modules/ec2"
  count               = 1
  ami                 = var.app_ami
  instance_type       = var.app_instance_type
  availability_zones  = var.availability_zones
  subnet_ids          = module.vpc.private_subnet_ids  # 서로 다른 AZ의 서브넷을 순차적으로 선택
  security_group_ids  = [module.sg.app_tier_sg_id]
  project_name        = var.project_name

  # IAM 인스턴스 프로파일 전달
  iam_instance_profile = module.iam.iam_instance_profile

  # RDS 연결 정보 전달 (엔드포인트로 변경)
  db_username         = var.db_username
  db_password         = var.db_password
  rds_endpoint        = module.rds.rds_endpoint
}

# 앱 서버 AMI 생성
module "app_server_ami" {
  source        = "./modules/ec2"
  ami_id   = module.app_server.app_server_id  # 생성할 웹 서버 인스턴스 ID를 전달
  project_name  = var.project_name
}


# 웹 서버 생성
module "web_server" {
  source              = "./modules/ec2"
  count               = 1
  ami                 = var.web_ami
  instance_type       = var.web_instance_type
  availability_zones  = var.availability_zones
  subnet_ids          = module.vpc.public_subnet_ids  # 서로 다른 AZ의 서브넷을 순차적으로 선택
  security_group_ids  = [module.sg.web_tier_sg_id]
  project_name        = var.project_name

  # IAM 인스턴스 프로파일 전달
  iam_instance_profile = module.iam.iam_instance_profile

  # App Server의 Private IP 전달
  app_server_private_ip = module.app_server[0].private_ip
}

# 웹 서버 AMI 생성
module "web_server_ami" {
  source        = "./modules/ec2"
  ami_id   = module.web_server.web_server_id  # 생성할 웹 서버 인스턴스 ID를 전달
  project_name  = var.project_name
}