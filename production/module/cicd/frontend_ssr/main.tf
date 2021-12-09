resource "aws_ecr_repository" "example_backend_ecr" {
  name                 = var.ssr_ecr_name
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


# backend用codepipeline、codebuild
resource "aws_codepipeline" "example_codepipeline" {
  name     = "sample_code_pipeline"
  role_arn = module.cicd_policy.codepipeline_role

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
        FullRepositoryId = var.ssr_repo
        BranchName       = var.ssr_branch
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
  artifact_store {
    location = aws_s3_bucket.example_backend_artifact.id
    type     = "S3"
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
  name         = var.ssr_codebuild_name
  service_role = module.cicd_policy.codebuild_role


  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = var.ssr_buildspec
  }
}


resource "aws_s3_bucket" "example_backend_artifact" {
  bucket        = var.ssr_artifact_bucket
  force_destroy = true
}


# nginx用codebuild
resource "aws_codebuild_project" "example_nginx_project" {
  name         = var.nginx_codebuild_name
  service_role = module.cicd_policy.codebuild_role

  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
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
