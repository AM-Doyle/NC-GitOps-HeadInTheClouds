resource "aws_db_subnet_group" "db-subnet-group" {
  name_prefix       = var.db-subnet-group-name
  subnet_ids = var.subnet_ids

  tags = {
    Name = "DB group project subnet group"
  }
}

# rds

resource "aws_db_instance" "db-group-project" {
  allocated_storage    = 10
  db_name              = var.db_name
  identifier = "db-group-project"

  engine               = var.engine
  engine_version       = var.engine_version

  instance_class       = var.instance_class
  skip_final_snapshot = true
  publicly_accessible = true

  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = var.vpc_security_group_ids

  username             = local.db_creds.POSTGRES_USERNAME
  password             = local.db_creds.POSTGRES_PASSWORD
}


data "aws_secretsmanager_secret_version" "secret-version"{
    secret_id = "db-group-project-credentials"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)
}