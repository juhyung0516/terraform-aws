# modules/ec2/main.tf

resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<EOF
        #!/bin/bash
        # 업데이트 및 필요한 패키지 설치
        yum update -y
        yum install -y httpd wget mariadb

        # HTTP 서비스 시작
        systemctl start httpd
        systemctl enable httpd

        # Web Server가 접근할 수 있는 App Server 테스트 페이지 생성
        cat <<EOT > /var/www/html/test
        <html>
        <head><title>App Server - 연결 테스트</title></head>
        <body>
        <h1>App Server - Web Server로부터의 연결 확인됨</h1>
        <p>App Server 연결 성공</p>
        </body>
        </html>
        EOT

        # DB 연결 테스트 페이지 생성
        cat <<EOT > /var/www/html/db_test
        <html>
        <head><title>App Server - DB 연결 테스트</title></head>
        <body>
        <h1>App Server - DB 연결 테스트 결과</h1>
        EOT

        # DB 연결 확인 및 결과 출력 스크립트
        cat <<'EOT' >> /var/www/html/db_test
        <?php
        $servername = "${var.rds_endpoint}";
        $username = "${var.db_username}";
        $password = "${var.db_password}";

        $conn = new mysqli($servername, $username, $password);

        if ($conn->connect_error) {
            echo "<p>DB 연결 실패: " . $conn->connect_error . "</p>";
        } else {
            echo "<p>DB 연결 성공</p>";
        }
        $conn->close();
        ?>
        </body>
        </html>
        EOT
EOF

  tags = {
    Name = "${var.project_name}-app-server"
  }
}

# modules/ec2/main.tf (User Data 부분만)

# modules/ec2/main.tf (User Data 부분만 수정)

resource "aws_instance" "web_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<EOF
#!/bin/bash
# 업데이트 및 필요한 패키지 설치
yum update -y
yum install -y httpd wget

# HTTP 서비스 시작 및 활성화
systemctl start httpd
systemctl enable httpd

# App Server 및 DB 연결 테스트 페이지 생성
cat <<EOT > /var/www/html/index.html
<html>
<head><title>Web Server - 연결 테스트</title></head>
<body>
<h1>Web Server - 연결 테스트 페이지</h1>

<!-- App Server 연결 테스트 -->
<h2>1. App Server 연결 테스트</h2>
<iframe src="http://${var.app_server_private_ip}/test" width="600" height="200" frameborder="0">
<p>App Server 연결 확인 실패 - App Server의 상태를 확인해주세요.</p>
</iframe>

<!-- DB 연결 테스트 결과 표시 -->
<h2>2. DB 연결 테스트 결과</h2>
<iframe src="http://${var.app_server_private_ip}/db_test" width="600" height="200" frameborder="0">
<p>DB 연결 확인 실패 - App Server 및 DB 설정을 확인해주세요.</p>
</iframe>

</body>
</html>
EOT
EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}
