terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Choose a free-tier eligible region
}

# PostgreSQL provider for instance 1 (duplicate for instance 2 if needed)
provider "postgresql" {
  alias    = "instance_1"
  host     = aws_db_instance.postgres_instance_1.address
  port     = 5432
  username = var.db_username
  password = var.db_password
  sslmode  = "require"  # Required for RDS
  superuser = false     # RDS master isn't full superuser
  expected_version = aws_db_instance.postgres_instance_1.engine_version
  connect_timeout = 15
}

provider "postgresql" {
  alias    = "instance_2"
  host     = aws_db_instance.postgres_instance_2.address
  port     = 5432
  username = var.db_username
  password = var.db_password
  sslmode  = "require"
  superuser = false
  expected_version = aws_db_instance.postgres_instance_2.engine_version
  connect_timeout = 15
}