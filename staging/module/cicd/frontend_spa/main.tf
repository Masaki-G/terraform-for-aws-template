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
    buildspec = var.spa_buildspec
  }
}


resource "aws_s3_bucket" "example_backend_artifact" {
  bucket        = var.spa_artifact_bucket
  force_destroy = true
}