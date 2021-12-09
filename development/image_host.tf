#画像用のs3、cloudfront構築
module "frontend" {
<<<<<<< HEAD
  source = "./module/image_host"
  bucket_name ="dev-example-s3"
  acl = "private"
=======
  source      = "./module/image_host"
  bucket_name = "dev-mitsuibau-bucket"
  acl         = "private"
>>>>>>> c36c93c9edeb47bb58e89c43f4df4fc5f9b1741b
}