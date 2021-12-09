#画像用のs3、cloudfront構築
module "frontend" {
  source      = "./module/image_host"
  bucket_name = "prod-example-s3"
  acl         = "private"
}