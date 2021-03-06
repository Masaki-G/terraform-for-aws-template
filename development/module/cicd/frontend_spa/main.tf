module "cicd_policy" {
  source = "../policy"
}

module "spa_codebuild_role" {
  source     = "../../iam"
  name       = "spa_codebuild_role"
  identifier = "codebuild.amazonaws.com"
  policy     = module.cicd_policy.codebuild_policy
}

module "spa_codepipeline_role" {
  source     = "../../iam"
  name       = "spa_codepipeline_role"
  identifier = "codepipeline.amazonaws.com"
  policy     = module.cicd_policy.codepipeline_policy
}

# backend用codepipeline、codebuild
resource "aws_codepipeline" "example_codepipeline" {
  name     = "frontend_code_pipeline"
  role_arn = module.spa_codepipeline_role.iam_role_arn

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
        FullRepositoryId = var.spa_repo
        BranchName       = var.spa_branch
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
}


resource "aws_codebuild_project" "example_backend_project" {
  name         = var.spa_codebuild_name
  service_role = module.spa_codebuild_role.iam_role_arn


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
    buildspec = var.spa_buildspec
  }
}


resource "aws_s3_bucket" "example_backend_artifact" {
  bucket        = var.spa_artifact_bucket
  force_destroy = true
}