output "db_endpoint" {
  value = aws_db_instance.example_rds.endpoint
}
output "db_name" {
  value = aws_db_instance.example_rds.name
}
output "db_port" {
  value = aws_db_instance.example_rds.port
}
output "db_username" {
  value = aws_db_instance.example_rds.username
}
output "db_password" {
  value = aws_db_instance.example_rds.password
}