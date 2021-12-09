resource "aws_ssm_parameter" "db_username" {
  name        = "/prod/db/username"
  type        = "String"
  value       = var.db_username
  description = "データーベースユーザー名"
}
resource "aws_ssm_parameter" "db_password" {
  name        = "/prod/db/password"
  type        = "String"
  value       = var.db_password
  description = "データーベースパスワード"
}
resource "aws_ssm_parameter" "db_port" {
  name        = "/prod/db/port"
  type        = "String"
  value       = var.db_port
  description = "データーベースポート"
}
resource "aws_ssm_parameter" "db_host" {
  name  = "/prod/db/host"
  type  = "String"
  value = replace(var.db_endpoint, ":3306", "")
  description = "データーベースホスト"
}
resource "aws_ssm_parameter" "db_database" {
  name        = "/prod/db/database"
  type        = "String"
  value       = var.db_name
  description = "データーベース名"
}
