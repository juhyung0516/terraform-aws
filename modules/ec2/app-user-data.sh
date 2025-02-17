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
$servername = "${rds_endpoint}";
$username = "${db_username}";
$password = "${db_password}";

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
