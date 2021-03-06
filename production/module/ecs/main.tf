
module "nginx-sg" {
  source      = "../../module/security_group"
  name        = "prod-nginx-sg"
  vpc_id      = var.vpc_id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_ecs_cluster" "example_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "example_backend_taskdifinition" {
  family = "prod-backend"
  cpu = "2048"
  memory = "4096"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = file("./backend_container_definitions.json")
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn

}