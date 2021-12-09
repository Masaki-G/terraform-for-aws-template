//#frontend用(spa_cloudfront)cicd
module "cicd_frontend_spa" {
<<<<<<< HEAD
  source = "./module/cicd/frontend_spa"
  spa_codebuild_name  = "dev-frontend-codebuild"
  spa_buildspec       = "buildspec/development.yml"
  spa_artifact_bucket = "dev-frontend-s3-artifact"
  source_connection   = "xxxxxxx"
  spa_repo            = "xxxxx/xxxxxx"
=======
  source              = "./module/cicd/frontend_spa"
  spa_codebuild_name  = "dev-frontend-codebuild"
  spa_buildspec       = "buildspec/development.yml"
  spa_artifact_bucket = "frontend-mitsuibau-s3-artifact"
  source_connection   = "arn:aws:codestar-connections:ap-northeast-1:594955594561:connection/64c840b7-1464-43ce-9219-a979488a9735"
  spa_repo            = "fignny/mitsuibau-frontend"
>>>>>>> c36c93c9edeb47bb58e89c43f4df4fc5f9b1741b
  spa_branch          = "develop"
}

#SPA用cloudfront
module "spa_cloudfront" {
  source              = "./module/spa_cloudfront"
<<<<<<< HEAD
  bucket_name         = "dev-example-spa-cloudfront"
  acl                 = "private"
  domain_name         = "dev.xxxx.xxxx"
=======
  bucket_name         = "dev-mitsuibau-spa-cloudfront"
  acl                 = "private"
  domain_name         = "dev.mitsuibau.jp"
>>>>>>> c36c93c9edeb47bb58e89c43f4df4fc5f9b1741b
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
<<<<<<< HEAD
  acm_certificate_domain_name = "dev.xxxx.coxxxxm"
  zone_id                     = "xxxxxx"
=======
  acm_certificate_domain_name = "dev.mitsuibau.jp"
  zone_id                     = "Z06949933ALWUUNMLE4NO" #対象のzoneId
>>>>>>> c36c93c9edeb47bb58e89c43f4df4fc5f9b1741b
  route53_record_name         = "dev"
  providers = {
    aws = aws.east
  }
}