data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "codebuild:StartBuild",
      "codebuild:StartBuildBatch",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:zescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "codebuild:*",
      "s3:*",
      "iam:PassRole",
      "cloudfront:*"
    ]
  }
}
data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:PassRole",
      "codestar-connections:UseConnection"
    ]
  }
}



//module "ssr_codebuild_role" {
//  source     = "../../iam"
//  name       = "ssr_codebuild_role"
//  identifier = "codebuild.amazonaws.com"
//  policy     = data.aws_iam_policy_document.codebuild_policy.json
//}
//
//module "ssr_codepipeline_role" {
//  source     = "../../iam"
//  name       = "ssr_codepipeline_role"
//  identifier = "codepipeline.amazonaws.com"
//  policy     = data.aws_iam_policy_document.codepipeline_policy.json
//}