output "codebuild_role" {
  value = module.codebuild_role.iam_role_arn
}

output "codepipeline_role" {
  value = module.codepipeline_role.iam_role_arn
}