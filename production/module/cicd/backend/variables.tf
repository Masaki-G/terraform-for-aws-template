variable "bakcend_codebuild_name" {}
variable "backend_buildspec" {}
variable "backend_artifact_bucket" {}
variable "source_connection" {}
variable "backend_repo" {}
variable "backend_branch" {}
variable "backend_ecr_name" {}

variable "nginx_buildspec" {}
variable "nginx_source_location" {}
variable "nginx_push_branch" {}
variable "nginx_codebuild_name" {}
variable "nginx_ecr_name" {}

variable "github_token" {}

variable "cluster_name" {}
variable "service_name" {}
variable "image_file" {}