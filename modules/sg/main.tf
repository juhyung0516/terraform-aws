# 1. External Load Balancer Security Group
resource "aws_security_group" "external_lb" {
  name        = "${var.project_name}-external-load-balancer-sg"
  description = "Security group for external load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }

    # ICMP (ping) 허용
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  

  tags = {
    Name = "${var.project_name}-external-lb-sg"
  }
}

# 2. Web Tier Security Group
resource "aws_security_group" "web_tier" {
  name        = "${var.project_name}-web-tier-sg"
  description = "Security group for web tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_groups          = [aws_security_group.external_lb.id]
    description              = "Allow HTTP from external load balancer"
  }

    # ICMP (ping) 허용
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-tier-sg"
  }
}

# 3. Internal Load Balancer Security Group
resource "aws_security_group" "internal_lb" {
  name        = "${var.project_name}-internal-load-balancer-sg"
  description = "Security group for internal load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_groups          = [aws_security_group.web_tier.id]
    description              = "Allow HTTP from web tier"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-internal-lb-sg"
  }
}

# 4. Application Tier Security Group
resource "aws_security_group" "app_tier" {
  name        = "${var.project_name}-app-tier-sg"
  description = "Security group for application tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 4000
    to_port                  = 4000
    protocol                 = "tcp"
    security_groups          = [aws_security_group.internal_lb.id]
    description              = "Allow traffic on port 4000 from internal load balancer"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-tier-sg"
  }
}

# 5. Database Tier Security Group
resource "aws_security_group" "db_tier" {
  name        = "${var.project_name}-db-tier-sg"
  description = "Security group for database tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups          = [aws_security_group.app_tier.id]
    description              = "Allow MySQL traffic from application tier"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-tier-sg"
  }
}