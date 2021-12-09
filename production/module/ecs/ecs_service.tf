resource "aws_ecs_service" "example_backend_service" {
  name = "prod-backend"
  cluster = aws_ecs_cluster.example_cluster.arn
  task_definition = aws_ecs_task_definition.example_backend_taskdifinition.arn
  desired_count = 2
  launch_type = "FARGATE"
  platform_version = "LATEST"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [module.nginx-sg.security_group_id]
    subnets = [
      var.private_subnet_1,]
  }
  load_balancer {
    target_group_arn = var.alb_target_group
    container_name = "web-backend-nginx"
    container_port = 80
  }
}

resource "aws_cloudwatch_log_group" "example_backend_log" {
  name              = var.backend_log
  retention_in_days = 180
}