#frontend用(ssr)cicd
module "cicd_ssr" {
  source              = "./module/cicd/frontend_ssr"
  ssr_codebuild_name  = "prod-frontend-codebuild"
  ssr_buildspec       = "buildspec/production.yml"
  ssr_artifact_bucket = "prod-frontend-s3-artifact"
  source_connection   = "xxxxxxx"
  ssr_repo            = "xxxxx/xxxxxx"
  ssr_branch          = "main"
  ssr_ecr_name        = "prod-frontend"

  nginx_buildspec       = "containers/nginx/buildspec.yml"
  nginx_source_location = "https://github.com/xxxxxxxxx"
  nginx_push_branch     = "main"
  nginx_codebuild_name  = "prod-frontend-nginx_codebuild"
  nginx_ecr_name        = "prod-frontend-nginx"

  github_token = "xxxxxx"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
  image_file   = "imagedifinitions.json"
}