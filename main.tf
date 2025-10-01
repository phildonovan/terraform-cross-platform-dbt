data "aws_vpc" "default" {
  default = true
}

# Custom security group (updated to use data source)
resource "aws_security_group" "rds_sg" {
  name        = "demo-rds-sg"
  description = "Allow inbound to RDS PostgreSQL"
  vpc_id      = data.aws_vpc.default.id  # Use data source here to break cycle

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP/32 for production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres_instance_1" {
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "16.8"  # Compatible with free tier; check AWS for latest
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
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_instance" "postgres_instance_2" {
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "16.8"
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
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

## PostgreSQL Providers for each instance
# For instance 1
resource "postgresql_database" "mydatabase_1" {
  provider = postgresql.instance_1
  name     = "mydatabase"
  depends_on = [aws_db_instance.postgres_instance_1]
}

resource "postgresql_schema" "myschema_1" {
  provider  = postgresql.instance_1
  database  = postgresql_database.mydatabase_1.name
  name      = "myschema"
  depends_on = [postgresql_database.mydatabase_1]
}

# For instance 2 (duplicate pattern)
resource "postgresql_database" "mydatabase_2" {
  provider = postgresql.instance_2
  name     = "mydatabase"
  depends_on = [aws_db_instance.postgres_instance_2]
}

resource "postgresql_schema" "myschema_2" {
  provider  = postgresql.instance_2
  database  = postgresql_database.mydatabase_2.name
  name      = "myschema"
  depends_on = [postgresql_database.mydatabase_2]
}

output "endpoint_instance_1" {
  value = aws_db_instance.postgres_instance_1.endpoint
}

output "endpoint_instance_2" {
  value = aws_db_instance.postgres_instance_2.endpoint
}

# Security group to allow inbound access (for demo purposes)
