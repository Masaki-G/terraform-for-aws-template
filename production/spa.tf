#frontend用(spa_cloudfront)cicd
module "cicd_frontend_spa" {
  source = "./module/cicd/frontend_spa"
  spa_codebuild_name  = "prod-frontend-codebuild"
  spa_buildspec       = "buildspec/production.yml"
  spa_artifact_bucket = "prod-frontend-s3-artifact-2021-12-3"
  source_connection   = "arn:aws:codestar-connections:ap-northeast-1:594955594561:connection/64c840b7-1464-43ce-9219-a979488a9735"
  spa_repo            = "fignny/mitsuibau-frontend"
  spa_branch          = "main"
}

#SPA用cloudfront
module "spa_cloudfront" {
  source              = "./module/spa_cloudfront"
  bucket_name         = "prod-mitsuibau-spa-cloudfront"
  acl                 = "private"
  domain_name         = "mitsuibau.jp"
  acm_certificate_arn = module.acm.cloudfront-acm
  sid                 = "Allow cloudfront"
//  allowed_methods = []
//  cached_methods = []
}

#SPA用cloudfrontのssl証明書
module "acm" {
  source                      = "./module/acm"
  cloudfront_id               = module.spa_cloudfront.spa_cloudfront_id
  cloudfront_name             = module.spa_cloudfront.spa_cloudfront_name
  acm_certificate_domain_name = "mitsuibau.jp"
  zone_id                     = "Z06949933ALWUUNMLE4NO" #対象のzoneId
  route53_record_name         = "mitsuibau.jp"

  providers = {
    aws = aws.east
  }
}