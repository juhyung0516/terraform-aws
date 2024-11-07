resource "aws_db_instance" "primary" {
  identifier              = "${var.project_name}-primary-db"
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.db_parameter_group_name
  multi_az                = var.multi_az
  publicly_accessible     = false
  vpc_security_group_ids  = var.security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.project_name}-primary-db"
  }
}

resource "aws_db_instance" "backup" {
  identifier              = "${var.project_name}-backup-db"
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  db_name                 = var.db_backup_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.db_parameter_group_name
  multi_az                = var.multi_az
  publicly_accessible     = false
  vpc_security_group_ids  = var.security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.project_name}-backup-db"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}