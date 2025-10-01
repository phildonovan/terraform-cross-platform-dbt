resource "aws_db_instance" "postgres_instance_1" {
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "16.1"  # Compatible with free tier; check AWS for latest
  instance_class        = "db.t3.micro"
  identifier            = "demo-postgres-1"
  db_name               = "demodb1"
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = "default.postgres16"
  skip_final_snapshot   = true  # Allows easy destruction without snapshot
  publicly_accessible   = true  # For demo access; set to false in production
  storage_encrypted     = false # Free tier doesn't require encryption
  multi_az              = false # Single-AZ to stay free
  backup_retention_period = 0   # No backups for demo
  apply_immediately     = true
}

resource "aws_db_instance" "postgres_instance_2" {
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "16.1"
  instance_class        = "db.t3.micro"
  identifier            = "demo-postgres-2"
  db_name               = "demodb2"
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = "default.postgres16"
  skip_final_snapshot   = true
  publicly_accessible   = true
  storage_encrypted     = false
  multi_az              = false
  backup_retention_period = 0
  apply_immediately     = true
}

output "endpoint_instance_1" {
  value = aws_db_instance.postgres_instance_1.endpoint
}

output "endpoint_instance_2" {
  value = aws_db_instance.postgres_instance_2.endpoint
}