# modules/ec2/main.tf

resource "aws_instance" "ec2_instance" {
  count               = length(var.subnet_ids)  # 각 서브넷에 인스턴스를 생성
  ami                 = var.ami
  instance_type       = var.instance_type
  subnet_id           = var.subnet_ids[count.index]  # 서브넷 배열에서 하나씩 할당
  vpc_security_group_ids = var.security_group_ids  # 보안 그룹 연동

  # SSM을 사용하기 위한 IAM Role을 추가합니다.
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  # 기타 EC2 인스턴스 설정...
  tags = {
    Name = "${var.instance_type}-instance-${count.index + 1}"
  }
}

# SSM 연결을 위한 IAM Role
resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# SSM 관리형 정책을 IAM Role에 연결
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM 인스턴스 프로파일
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "EC2SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}
