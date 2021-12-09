variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

terraform {
  required_version = "0.15.2"

  required_providers {
    aws      = "3.53.0"
    null     = "3.1.0"
  }
}

provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.region
}

provider "aws" {
  alias      = "east"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = "us-east-1"
}

//#ALB用vpc、サブネット
//module "subnet" {
//  source               = "./module/subnet"
//  tag                  = "vpc"
//  cidr_block           = "10.0.0.0/21"
//  tag_public_1         = "public_subnet_1"
//  tag_public_2         = "public_subnet_2"
//  availability_zone_1  = "ap-northeast-1a"
//  availability_zone_2  = "ap-northeast-1c"
//  cidr_blocks_public_1 = "10.0.1.0/24"
//  cidr_blocks_public_2 = "10.0.2.0/24"
//
//  tag_private_1         = "private_subnet_1"
//  tag_private_2         = "private_subnet_2"
//  cidr_blocks_private_1 = "10.0.3.0/24"
//  cidr_blocks_private_2 = "10.0.4.0/24"
//}
//
//module "alb" {
//  source = "./module/alb"
//
//  alb_name                    = "alb"
//  public_subnet_1             = module.subnet.public_subnet_1
//  public_subnet_2             = module.subnet.public_subnet_2
//  vpc_id                      = module.subnet.vpc
//  acm_certificate_domain_name = "example.hoge.com"
//  recode_name                 = "example"
//  zone_id                     = "xxxxxxxxxx"
//  security_group_name         = "example"
//}
//
//#Fargate
//module "ecs" {
//  source           = "./module/ecs"
//  private_subnet_1 = module.subnet.private_subnet_1
//  vpc_id           = module.subnet.vpc
//  backend_log      = "/ecs/example"
//  alb_target_group = module.alb.target_group
//  cluster_name     = "example-cluster"
//
//}
//
//#DB
//module "rds" {
//  source         = "./module/rds"
//  private_subnet = [module.subnet.private_subnet_1, module.subnet.private_subnet_2]
//  rds_name       = "example-rds"
//  vpc_id         = module.subnet.vpc
//  password       = "xxxxxxx"
//  database_name  = "example-db"
//
//}
//
//#環境変数管理
//module "ssm" {
//  source      = "./module/ssm"
//  db_name     = module.rds.db_name
//  db_username = module.rds.db_username
//  db_endpoint = module.rds.db_endpoint
//  db_port     = module.rds.db_port
//  db_password = module.rds.db_password
//}
//
//#画像用のs3、cloudfront構築
//module "frontend" {
//  source = "./module/image_host"
//  bucket_name ="example-s3"
//  acl = "private"
//}
//
//#frontend用(ssr)cicd
//module "cicd_backend" {
//  source              = "./module/cicd/frontend_ssr"
//  ssr_codebuild_name  = "example-codebuild"
//  ssr_buildspec       = "buildspec/development.yml"
//  ssr_artifact_bucket = "example-s3-artifact"
//  source_connection   = "arn:aws:codestar-connections:ap-northeast-1:700562912253:connection/57ae0d94-2208-4cca-958a-b20107698786"
//  ssr_repo            = "fignny/xxxxxx"
//  ssr_branch          = "develop"
//  ssr_ecr_name        = "dev-example"
//
//  nginx_buildspec       = "containers/nginx/buildspec.yml"
//  nginx_source_location = "https://github.com/fignny/reborn-api.git"
//  nginx_push_branch     = "develop"
//  nginx_codebuild_name  = "nginx_codebuild"
//  nginx_ecr_name        = "web-frontend-nginx"
//
//  github_token = "xxxxxx"
//
//  cluster_name = module.ecs.cluster_name
//  service_name = module.ecs.service_name
//  image_file   = "imagedifinitions.json"
//}
//
//#frontend用(spa_cloudfront)cicd
//module "cicd_frontend_spa" {
//  source = "./module/cicd/frontend_spa"
//  spa_codebuild_name  = "example-codebuild"
//  spa_buildspec       = "buildspec/development.yml"
//  spa_artifact_bucket = "example-s3-artifact"
//  source_connection       = "arn:aws:codestar-connections:ap-northeast-1:700562912253:connection/57ae0d94-2208-4cca-958a-b20107698786"
//  spa_repo            = "fignny/xxxxxx"
//  spa_branch          = "develop"
//  spa_ecr_name        = "dev-example"
//}
//
//#backend用cicd
//module "cicd_backend" {
//  source                  = "./module/cicd/backend"
//  bakcend_codebuild_name  = "example-codebuild"
//  backend_buildspec       = "buildspec/development.yml"
//  backend_artifact_bucket = "example-s3-artifact"
//  source_connection       = "arn:aws:codestar-connections:ap-northeast-1:700562912253:connection/57ae0d94-2208-4cca-958a-b20107698786"
//  backend_repo            = "fignny/xxxxx"
//  backend_branch          = "develop"
//  backend_ecr_name        = "dev-example-api"
//
//  nginx_buildspec       = "containers/nginx/buildspec.yml"
//  nginx_source_location = "https://github.com/fignny/xxxxxxx"
//  nginx_push_branch     = "develop"
//  nginx_codebuild_name  = "nginx_codebuild"
//  nginx_ecr_name        = "web-backend-nginx"
//
//  github_token = "xxxxxx"
//
//  cluster_name = module.ecs.cluster_name
//  service_name = module.ecs.service_name
//  image_file   = "imagedifinitions.json"
//
//}
//
//#SPA用cloudfront
//module "spa_cloudfront" {
//  source              = "./module/spa_cloudfront"
//  bucket_name         = "spa_cloudfront-bucket"
//  acl                 = "private"
//  domain_name         = "example.hoge.com"
//  acm_certificate_arn = module.acm.cloudfront-acm
//  sid                 = "Allow cloudfront"
////  allowed_methods = []
////  cached_methods = []
//}
//
//#SPA用cloudfrontのssl証明書
//module "acm" {
//  source                      = "./module/acm"
//  cloudfront_id               = module.spa_cloudfront.spa_cloudfront_id
//  cloudfront_name             = module.spa_cloudfront.spa_cloudfront_name
//  acm_certificate_domain_name = "example.hoge.com"
//  zone_id                     = "xxxxxx" #対象のzoneId
//  route53_record_name         = "example"
//  providers = {
//    aws = aws.east
//  }
//}


