variable "db_username" {
  type        = string
  description = "Database admin username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database admin password"
  sensitive   = true
}