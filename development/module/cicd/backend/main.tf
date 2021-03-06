resource "aws_ecr_repository" "example_backend_ecr" {
  name                 = var.backend_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "web-backend-nginx" {
  name                 = var.nginx_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

module "cicd_policy" {
  source = "../policy"
}

module "backend_codebuild_role" {
  source     = "../../iam"
  name       = "backend_codebuild_role"
  identifier = "codebuild.amazonaws.com"
  policy     = module.cicd_policy.codebuild_policy
}

module "backend_codepipeline_role" {
  source     = "../../iam"
  name       = "backend_codepipeline_role"
  identifier = "codepipeline.amazonaws.com"
  policy     = module.cicd_policy.codepipeline_policy
}

# backend用codepipeline、codebuild
resource "aws_codepipeline" "example_codepipeline" {
  name     = "backend_code_pipeline"
  role_arn = module.backend_codepipeline_role.iam_role_arn

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = 1
      output_artifacts = ["Source"]
      configuration = {
        ConnectionArn    = var.source_connection
        FullRepositoryId = var.backend_repo
        BranchName       = var.backend_branch
      }
    }
  }

  stage {
    name = "Build"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]
      configuration = {
        ProjectName = aws_codebuild_project.example_backend_project.id
      }
    }
  }

  stage {
    name = "deploy"
    action {
      category        = "Deploy"
      name            = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["Build"]
      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
        FileName    = var.image_file
      }
    }
  }
  artifact_store {
    location = aws_s3_bucket.example_backend_artifact.id
    type     = "S3"
  }
}

resource "aws_codebuild_project" "example_backend_project" {
  name         = var.bakcend_codebuild_name
  service_role = module.backend_codebuild_role.iam_role_arn


  artifacts {
    type = "CODEPIPELINE"
  }
  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }
  environment {
    compute_type    = "BUILD_GENERAL1_LARGE"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = var.backend_buildspec
  }
}


resource "aws_s3_bucket" "example_backend_artifact" {
  bucket        = var.backend_artifact_bucket
  force_destroy = true
}


# nginx用codebuild
resource "aws_codebuild_project" "example_nginx_project" {
  name         = var.nginx_codebuild_name
  service_role = module.backend_codebuild_role.iam_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }
  environment {
    compute_type    = "BUILD_GENERAL1_LARGE"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
  source {
    type                = "GITHUB"
    location            = var.nginx_source_location
    git_clone_depth     = 1
    report_build_status = true
    buildspec           = var.nginx_buildspec
  }
  source_version = "refs/heads/master"
}

resource "aws_codebuild_source_credential" "example_codebuild" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_token
}

resource "aws_codebuild_webhook" "sample_codebuild" {
  project_name = aws_codebuild_project.example_nginx_project.name

  // masterブランチpush時
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.nginx_push_branch
    }
  }
}
