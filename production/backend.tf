////#ALB用vpc、サブネット
//module "subnet" {
//  source               = "./module/subnet"
//  tag                  = "vpc"
//  cidr_block           = "10.0.0.0/21"
//  tag_public_1         = "prod-public_subnet_1"
//  tag_public_2         = "prod-public_subnet_2"
//  availability_zone_1  = "ap-northeast-1a"
//  availability_zone_2  = "ap-northeast-1c"
//  cidr_blocks_public_1 = "10.0.1.0/24"
//  cidr_blocks_public_2 = "10.0.2.0/24"
//
//  tag_private_1         = "prod-private_subnet_1"
//  tag_private_2         = "prod-private_subnet_2"
//  cidr_blocks_private_1 = "10.0.3.0/24"
//  cidr_blocks_private_2 = "10.0.4.0/24"
//}
//
//module "alb" {
//  source = "./module/alb"
//
//  alb_name                    = "prod-alb"
//  public_subnet_1             = module.subnet.public_subnet_1
//  public_subnet_2             = module.subnet.public_subnet_2
//  vpc_id                      = module.subnet.vpc
//  acm_certificate_domain_name = "api.pro-cloud.co.jp"
//  recode_name                 = "api"
//  zone_id                     = "Z066022315IKRZMIHDQ3I"
//  security_group_name         = "prod-api-reborn"
//}
////
//#Fargate
//module "ecs" {
//  source           = "./module/ecs"
//  private_subnet_1 = module.subnet.private_subnet_1
//  vpc_id           = module.subnet.vpc
//  backend_log      = "/ecs/reborn-prod-api"
//  alb_target_group = module.alb.target_group
//  cluster_name     = "reborn-prod-cluster"
//
//}
////
//#backend用cicd
//module "cicd_backend" {
//  source                  = "./module/cicd/backend"
//  bakcend_codebuild_name  = "prod-backend-codebuild"
//  backend_buildspec       = "buildspec/production.yml"
//  backend_artifact_bucket = "prod-backend-s3-artifact"
//  source_connection       = "arn:aws:codestar-connections:ap-northeast-1:177970032147:connection/6899596e-aa72-4c1d-a55e-9d1837be0b5a"
//  backend_repo            = "fignny/reborn-api"
//  backend_branch          = "master"
//  backend_ecr_name        = "prod-reborn-api"
//
//  nginx_buildspec       = "containers/nginx/production.yml"
//  nginx_source_location = "https://github.com/fignny/reborn-api"
//  nginx_push_branch     = "master"
//  nginx_codebuild_name  = "prod-nginx_codebuild"
//  nginx_ecr_name        = "prod-web-backend-nginx"
//
//  github_token = "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"
//
//  cluster_name = module.ecs.cluster_name
//  service_name = module.ecs.service_name
//  image_file   = "imagedifinitions.json"
//
//}