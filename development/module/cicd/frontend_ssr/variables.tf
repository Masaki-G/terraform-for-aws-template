variable "ssr_codebuild_name" {}
variable "ssr_buildspec" {}
variable "ssr_artifact_bucket" {}
variable "source_connection" {}
variable "ssr_repo" {}
variable "ssr_branch" {}
variable "ssr_ecr_name" {}

variable "nginx_buildspec" {}
variable "nginx_source_location" {}
variable "nginx_push_branch" {}
variable "nginx_codebuild_name" {}
variable "nginx_ecr_name" {}

variable "github_token" {}

variable "cluster_name" {}
variable "service_name" {}
variable "image_file" {}