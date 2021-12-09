<<<<<<< HEAD
#frontend用(ssr)cicd
module "cicd_backend" {
  source              = "./module/cicd/frontend_ssr"
  ssr_codebuild_name  = "dev-frontend-codebuild"
  ssr_buildspec       = "buildspec/development.yml"
  ssr_artifact_bucket = "dev-frontend-s3-artifact"
  source_connection   = "xxxxxxx"
  ssr_repo            = "xxxxx/xxxxxx"
  ssr_branch          = "develop"
  ssr_ecr_name        = "dev-frontend"

  nginx_buildspec       = "containers/nginx/buildspec.yml"
  nginx_source_location = "https://github.com/xxxxxxxxx"
  nginx_push_branch     = "develop"
  nginx_codebuild_name  = "dev-frontend-nginx_codebuild"
  nginx_ecr_name        = "dev-frontend-nginx"

  github_token = "xxxxxx"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
  image_file   = "imagedifinitions.json"
}
=======
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
>>>>>>> c36c93c9edeb47bb58e89c43f4df4fc5f9b1741b
