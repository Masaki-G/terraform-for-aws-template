output "codebuild_policy" {
  value = data.aws_iam_policy_document.codebuild_policy.json
}

output "codepipeline_policy" {
  value = data.aws_iam_policy_document.codepipeline_policy.json
}