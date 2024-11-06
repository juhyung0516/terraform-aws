# rds/main.tf

# RDS 클러스터를 위한 서브넷 그룹 생성 (이미 전달받은 DB-tier 서브넷 IDs 사용)
resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = var.db_subnet_ids  # 전달받은 DB-tier 서브넷 IDs

  tags = {
    Name = "My-RDS-Subnet-Group"
  }
}

# RDS 클러스터 생성 (Aurora MySQL 호환)
resource "aws_rds_cluster" "my_rds_cluster" {
  cluster_identifier      = "my-rds"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.2"
  database_name           = "mydatabase"
  master_username         = var.db_master_username
  master_password         = var.db_master_password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  storage_encrypted       = true

  tags = {
    Name = "My-RDS-Cluster"
  }
}

# RDS 클러스터 인스턴스 생성
resource "aws_rds_cluster_instance" "my_rds_instance" {
  identifier            = "My-RDS-instance"
  cluster_identifier    = aws_rds_cluster.my_rds_cluster.id
  instance_class        = "db.t3.small"  # 작은 인스턴스 클래스
  engine                = aws_rds_cluster.my_rds_cluster.engine
  engine_version        = aws_rds_cluster.my_rds_cluster.engine_version
  publicly_accessible   = false
  db_subnet_group_name  = aws_db_subnet_group.my_subnet_group.name  # 생성된 서브넷 그룹 사용

  tags = {
    Name = "My-RDS-Instance"
  }
}
