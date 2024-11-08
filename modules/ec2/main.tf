# modules/ec2/main.tf

# 1 - 앱 서버 생성
# AMI를 생성할 EC2 인스턴스 정의 (앱 서버)
resource "aws_instance" "app_server" {
  count                  = 1  # 각 AZ에 하나씩 생성
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]  # AMI 생성용이므로 첫 번째만
  availability_zone      = var.availability_zones[0]  # AMI 생성용이므로 첫 번째만
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = templatefile("${path.module}/app-user-data.sh", {
    rds_endpoint = var.rds_endpoint
    db_username  = var.db_username
    db_password  = var.db_password
  })

  tags = {
    Name = "${var.project_name}-app-server"
  }
}

# # AMI 생성 (앱 서버)
# resource "aws_ami_from_instance" "app_server_ami" {
#   name               = "${var.project_name}-app-server-ami"
#   source_instance_id = aws_instance.app_server[0].id  # 첫 번째 인스턴스를 AMI 생성에 사용
#   depends_on         = [aws_instance.app_server]  # 앱 서버 생성 완료 후 AMI 생성
# }

# # 앱 서버의 Launch Template 생성 (AMI ID 참조)
# resource "aws_launch_template" "app_server_lt" {
#   name          = "${var.project_name}-app-server-lt"
#   image_id      = aws_ami_from_instance.app_server_ami.id  # 생성된 AMI ID를 직접 참조
#   instance_type = var.instance_type

#   # IAM Instance Profile 설정
#   iam_instance_profile {
#     name = var.iam_instance_profile
#   }

#   # 네트워크 인터페이스 설정
#   network_interfaces {
#     security_groups = [var.security_group_id]
#     subnet_id       = var.subnet_ids[1]
#   }

#   # User Data를 templatefile을 통해 외부 파일로부터 로드하고 변수 적용
#   user_data = templatefile("${path.module}/app-user-data.sh", {
#     rds_endpoint = var.rds_endpoint
#     db_username  = var.db_username
#     db_password  = var.db_password
#   })

#   # AMI 생성 이후에 Launch Template이 적용되도록 설정
#   depends_on = [aws_ami_from_instance.app_server_ami]
# }


# 3 - 웹 서버 생성
resource "aws_instance" "web_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0] # AMI 생성용이므로 첫 번째만
  availability_zone      = var.availability_zones[0] # AMI 생성용이므로 첫 번째만
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  # User Data를 templatefile을 통해 외부 파일로부터 로드하고 변수 적용
  user_data = templatefile("${path.module}/web-user-data.sh", {
    app_server_private_ip = var.app_server_private_ip
  })

  tags = {
    Name = "${var.project_name}-web-server"
  }
}

# # 4 - AMI 생성 (웹 서버)
# resource "aws_ami_from_instance" "web_server_ami" {
#   name               = "${var.project_name}-web-server-ami"
#   source_instance_id = aws_instance.web_server.id
#   depends_on         = [aws_instance.web_server]  # 웹 서버 생성 완료 후 AMI 생성
# }

# # Launch Template for App Server
# resource "aws_launch_template" "app_server_lt" {
#   name          = "${var.project_name}-app-server-lt"
#   image_id      = var.ami_id  # AMI ID 참조
#   instance_type = var.instance_type

#   iam_instance_profile {
#     name = var.iam_instance_profile
#   }

#   network_interfaces {
#     security_groups = [var.security_group_id]
#     subnet_id       = var.subnet_ids[1]  # 두 번째 서브넷
#   }

#   # User Data를 templatefile을 통해 외부 파일로부터 로드하고 변수 적용
#   user_data = templatefile("${path.module}/app-user-data.sh", {
#     rds_endpoint = var.rds_endpoint
#     db_username  = var.db_username
#     db_password  = var.db_password
#   })
# }

# # Launch Template for Web Server
# resource "aws_launch_template" "web_server_lt" {
#   name          = "${var.project_name}-web-server-lt"
#   image_id      = var.ami_id  # AMI ID 참조
#   instance_type = var.instance_type

#   iam_instance_profile {
#     name = var.iam_instance_profile
#   }

#   network_interfaces {
#     security_groups = [var.security_group_id]
#     subnet_id       = var.subnet_ids[1]  # 두 번째 서브넷
#   }

#   # User Data를 templatefile을 통해 외부 파일로부터 로드하고 변수 적용
#   user_data = templatefile("${path.module}/web-user-data.sh", {
#     app_server_private_ip = var.app_server_private_ip
#   })
# }
