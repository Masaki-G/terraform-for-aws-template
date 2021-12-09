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