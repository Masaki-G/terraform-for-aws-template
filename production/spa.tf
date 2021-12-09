#frontend用(spa_cloudfront)cicd
module "cicd_frontend_spa" {
  source = "./module/cicd/frontend_spa"
  spa_codebuild_name  = "prod-frontend-codebuild"
  spa_buildspec       = "buildspec/production.yml"
  spa_artifact_bucket = "prod-frontend-s3-artifact"
  source_connection   = "xxxxxxx"
  spa_repo            = "xxxxx/xxxxxx"
  spa_branch          = "main"
}

#SPA用cloudfront
module "spa_cloudfront" {
  source              = "./module/spa_cloudfront"
  bucket_name         = "prod-example-spa-cloudfront"
  acl                 = "private"
  domain_name         = "prod.xxxx.xxxx"
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
  acm_certificate_domain_name = "prod.xxxx.coxxxxm"
  zone_id                     = "xxxxxx"
  route53_record_name         = "prod"
  providers = {
    aws = aws.east
  }
}