output "cluster_name" {
  value = aws_ecs_cluster.example_cluster.name
}

output "service_name" {
  value = aws_ecs_service.example_backend_service.name
}