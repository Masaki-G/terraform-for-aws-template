#ALB用vpc、サブネット
module "subnet" {
  source               = "./module/subnet"
  tag                  = "vpc"
  cidr_block           = "10.0.0.0/21"
  tag_public_1         = "dev-public_subnet_1"
  tag_public_2         = "dev-public_subnet_2"
  availability_zone_1  = "ap-northeast-1a"
  availability_zone_2  = "ap-northeast-1c"
  cidr_blocks_public_1 = "10.0.1.0/24"
  cidr_blocks_public_2 = "10.0.2.0/24"

  tag_private_1         = "dev-private_subnet_1"
  tag_private_2         = "dev-private_subnet_2"
  cidr_blocks_private_1 = "10.0.3.0/24"
  cidr_blocks_private_2 = "10.0.4.0/24"
}

module "alb" {
  source = "./module/alb"

  alb_name                    = "alb"
  public_subnet_1             = module.subnet.public_subnet_1
  public_subnet_2             = module.subnet.public_subnet_2
  vpc_id                      = module.subnet.vpc
  acm_certificate_domain_name = "dev.xxx.xxx"
  recode_name                 = "dev"
  zone_id                     = "xxxxxxxxxx"
  security_group_name         = "dev-xxx-xxx"
}

#Fargate
module "ecs" {
  source           = "./module/ecs"
  private_subnet_1 = module.subnet.private_subnet_1
  vpc_id           = module.subnet.vpc
  backend_log      = "/ecs/example"
  alb_target_group = module.alb.target_group
  cluster_name     = "dev-example-cluster"

}

#backend用cicd
module "cicd_backend" {
  source                  = "./module/cicd/backend"
  bakcend_codebuild_name  = "dev-backend-codebuild"
  backend_buildspec       = "buildspec/development.yml"
  backend_artifact_bucket = "dev-example-s3-artifact"
  source_connection       = "xxxxx"
  backend_repo            = "xxxx/xxxxx"
  backend_branch          = "develop"
  backend_ecr_name        = "dev-example-api"

  nginx_buildspec       = "containers/nginx/buildspec.yml"
  nginx_source_location = "https://github.com/xxxxx/xxxxxxx"
  nginx_push_branch     = "develop"
  nginx_codebuild_name  = "dev-backend-nginx_codebuild"
  nginx_ecr_name        = "dev-backend-nginx"

  github_token = "xxxxxx"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
  image_file   = "imagedifinitions.json"

}