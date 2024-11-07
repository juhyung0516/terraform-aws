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

#RDS
# RDS 설정값들
db_name               = "mydatabase"
db_backup_name        = "mybackupdatabase"
db_username           = "admin"
db_password           = "securepassword123"
db_instance_class     = "db.t3.micro"
db_allocated_storage  = 20
db_engine             = "mysql"
db_parameter_group_name = "default.mysql8.0"
multi_az              = true

# ec2
web_instance_type      = "t3.micro"
web_ami                = "ami-03d31e4041396b53c"
app_instance_type      = "t3.micro"
app_ami                = "ami-03d31e4041396b53c"
