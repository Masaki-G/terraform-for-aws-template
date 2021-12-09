module "mysql_sg" {
  source      = "../security_group"
  name        = "mysql-sg"
  vpc_id      = var.vpc_id
  port        = 3306
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_db_parameter_group" "example_rds_parameter" {
  name   = "dev-rds-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_option_group" "example_rds_option" {
  name                 = "dev-rds-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

resource "aws_db_subnet_group" "example_rds_subnet" {
  name       = "dev-rds-subnet-group"
  subnet_ids = var.private_subnet
}


resource "aws_db_instance" "example_rds" {
  identifier                 = var.rds_name
  engine                     = "mysql"
  engine_version             = "8.0.23"
  instance_class             = "db.t3.small"
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = "gp2"
  storage_encrypted          = true
  name                       = var.database_name
  username                   = "admin"
  password                   = var.password
  multi_az                   = false
  publicly_accessible        = false
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = true
  skip_final_snapshot        = false
  final_snapshot_identifier  = true
  port                       = 3306
  apply_immediately          = false
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.example_rds_parameter.name
  option_group_name          = aws_db_option_group.example_rds_option.name
  db_subnet_group_name       = aws_db_subnet_group.example_rds_subnet.name

}