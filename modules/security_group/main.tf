# 1. External Load Balancer Security Group
resource "aws_security_group" "external_lb_sg" {
  name        = "External-Load-Balancer-SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "External-Load-Balancer-SG"
  }
}

# 2. Web Tier Security Group
resource "aws_security_group" "web_tier_sg" {
  name        = "Web-Tier-SG"
  vpc_id      = var.vpc_id

  ingress {
    description       = "Allow HTTP from External Load Balancer"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    security_groups   = [aws_security_group.external_lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-Tier-SG"
  }
}

# 3. Internal Load Balancer Security Group
resource "aws_security_group" "internal_lb_sg" {
  name        = "Internal-Load-Balancer-SG"
  vpc_id      = var.vpc_id

  ingress {
    description       = "Allow HTTP from Web Tier"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    security_groups   = [aws_security_group.web_tier_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Internal-Load-Balancer-SG"
  }
}

# 4. App Tier Security Group
resource "aws_security_group" "app_tier_sg" {
  name        = "App-Tier-SG"
  vpc_id      = var.vpc_id

  ingress {
    description       = "Allow port 4000 from Internal Load Balancer"
    from_port         = 4000
    to_port           = 4000
    protocol          = "tcp"
    security_groups   = [aws_security_group.internal_lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App-Tier-SG"
  }
}

# 5. DB Tier Security Group
resource "aws_security_group" "db_tier_sg" {
  name        = "DB-Tier-SG"
  vpc_id      = var.vpc_id

  ingress {
    description       = "Allow MySQL from App Tier"
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    security_groups   = [aws_security_group.app_tier_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-Tier-SG"
  }
}
