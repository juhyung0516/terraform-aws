# 필요한 변수 정의
variable "public_subnet_a" {
  description = "The ID of the first public subnet"
  type        = string
}

variable "public_subnet_b" {
  description = "The ID of the second public subnet"
  type        = string
}

# Launch Configuration 설정
resource "aws_launch_configuration" "three-tier-web-lconfig" {
  name          = "three-tier-web-launch-config"
  image_id      = "ami-12345678"   # 원하는 AMI ID로 변경
  instance_type = "t2.micro"       # 원하는 인스턴스 타입으로 설정
  # 필요에 따라 추가 설정 가능
}

# Auto Scaling Group 설정
resource "aws_autoscaling_group" "three-tier-web-asg" {
  name                 = "three-tier-web-asg"
  launch_configuration = aws_launch_configuration.three-tier-web-lconfig.id
  vpc_zone_identifier  = [var.public_subnet_a, var.public_subnet_b]  # 퍼블릭 서브넷 변수 사용
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2

  tag {
    key                 = "Name"
    value               = "three-tier-web-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300  # 헬스 체크 유예 시간 (초)

  force_delete              = true  # ASG 삭제 시 인스턴스도 함께 삭제
}
