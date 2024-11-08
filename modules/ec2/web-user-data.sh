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
<iframe src="http://${app_server_private_ip}/test" width="600" height="200" frameborder="0">
<p>App Server 연결 확인 실패 - App Server의 상태를 확인해주세요.</p>
</iframe>

<!-- DB 연결 테스트 결과 표시 -->
<h2>2. DB 연결 테스트 결과</h2>
<iframe src="http://${app_server_private_ip}/db_test" width="600" height="200" frameborder="0">
<p>DB 연결 확인 실패 - App Server 및 DB 설정을 확인해주세요.</p>
</iframe>

</body>
</html>
EOT
