![](https://img.shields.io/badge/terraform-0.15.2-blue)
![](https://img.shields.io/badge/aws-3.53.0-orange)
![](https://img.shields.io/badge/-TerraForm%20-232F3E.svg?logo=terraform&style=flat)

# template-terraform-for-aws
fignnyでよく使うaws構成をterraformで汎用的に作成しました。
- ECSのfargateによるサーバー管理不要なコンテナを実行するためのサーバー環境
- ECRによるコンテナ管理
- S3 + cloudfrontによるエッジサーバーからコンテンツの配信によるレスポンス速度の向上
- codepipeline codebuildを使用したcicd環境

# setup
clone後対象の環境のフォルダに移動

```
git clone git@github.com:fignny/template-terraform-for-aws.git
cd development
```
初期化
```
terraform init
```
credintial追加
```
export TF_VAR_aws_access_key_id="xxx"
export TF_VAR_aws_secret_access_key="xxx"
```
dry-run
```
terraform plan
```
実行
```
terraform apply
```
削除
```
terraform destroy
```

# description
- 環境ごとの直下のmain.tfファイルがapply時に実行されるファイル。main.tfファイルではそれぞれのmodule化したtfファイルを読み込んで使用する
- moduleディレクトリ配下のディレクトリ内でそれぞれのawsサービスをmodule化している。
```
main.tf → 実装するインフラ構成
variables.tf → main.tfで使用したい変数の定義
output.tf → main.tfで作成された成果物の出力
```


**それぞれのmodule化についての説明**

```
#acm
  SPAのフロント構成で行うためのcloudfrontの証明書を作成している。北バージニアで作成する必要があるため
  
#alb
  Fargate上にアクセスするためのALBを定義、HTTPSアクセスを前提としていてHTTPの場合はHTTPSにリダイレクトしている。HTTPSのために証明書取得もしている。

#cicd
  4つディレクトリがある。policyはそれぞれのディレクトリで使うcodebuildとcodepipelineのpolicyを定義している。
  それ以外の3つのフォルダはフォルダ名通りのcicdを定義

#ecs
  Fargateでbackendを動かすのを定義している

#iam
  iamの基盤を定義

#image_host
  画像や動画などを管理するs3 + cloudfront構成の定義

#rds
  backendで使用するrdsを定義

#security_group
  セキュリティグループの基盤を定義

#spa_cloudfront
  SPAでs3の静的コンテンツをcloudfrontで配信している

#ssm
  環境変数を定義

#subnet vpc
  subnetとvpcを定義
  
#backend_container_definitions.json
  fargateで使用するタスク定義ファイル
```

# usage
- main.tf
- 必要なものだけをコメントインする

```
#ALB用vpc、サブネット
module "subnet" {
  source               = "./module/subnet"
  tag                  = "vpc"
  cidr_block           = "10.0.0.0/21"  → vpcのIPv4アドレスの範囲
  tag_public_1         = "public_subnet_1"  → パブリックサブネット1のtag名
  tag_public_2         = "public_subnet_2"  → パブリックサブネット2のtag名
  availability_zone_1  = "ap-northeast-1a"  →  変数にAZの定義
  availability_zone_2  = "ap-northeast-1c"  →  変数にAZの定義
  cidr_blocks_public_1 = "10.0.1.0/24"  →  パブリックサブネット1のIPv4アドレスの範囲
  cidr_blocks_public_2 = "10.0.2.0/24"  →  パブリックサブネット2のIPv4アドレスの範囲

  tag_private_1         = "private_subnet_1"  → プライベートサブネットのtag名
  tag_private_2         = "private_subnet_2"  → プライベートサブネットのtag名
  cidr_blocks_private_1 = "10.0.3.0/24"  →  プライベートサブネット1のIPv4アドレスの範囲
  cidr_blocks_private_2 = "10.0.4.0/24"  →  プライベートサブネット2のIPv4アドレスの範囲
}

module "alb" {
  source = "./module/alb"

  alb_name                    = "alb"  →  alb名
  public_subnet_1             = module.subnet.public_subnet_1
  public_subnet_2             = module.subnet.public_subnet_2
  vpc_id                      = module.subnet.vpc
  acm_certificate_domain_name = "test.worker.cafe"  →  acmで使うドメイン名
  recode_name                 = "test"  →  レコード名
  zone_id                     = "ZGVBT55SBZLNB"  →  ホストゾーンのid
  security_group_name         = "services_s"  →  albで使うsgの名前
}

#Fargate
module "ecs" {
  source           = "./module/ecs"
  private_subnet_1 = module.subnet.private_subnet_1
  vpc_id           = module.subnet.vpc
  backend_log      = "/ecs/example"  → backendログの名前
  alb_target_group = module.alb.target_group
  cluster_name     = "reborn-cluster"  → clusterの名前

}

#DB
module "rds" {
  source         = "./module/rds"
  private_subnet = [module.subnet.private_subnet_1, module.subnet.private_subnet_2]
  rds_name       = "examplerds"  → rds名
  vpc_id         = module.subnet.vpc
  password       = "pBuqVfPXcsYLh7m"  → dbのパスワード
  database_name  = "exampledb"  → db名

}

#環境変数管理
module "ssm" {
  source      = "./module/ssm"
  db_name     = module.rds.db_name
  db_username = module.rds.db_username
  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_password = module.rds.db_password
}

#画像用のs3、cloudfront構築
module "frontend" {
  source = "./module/image_host"
  bucket_name ="hosting-s3-hogehoge"  → s3名
  acl = "private"  →s3のタイプ(cloudfrontかませるのでprivate)
}

#frontend用(ssr)cicd
module "cicd_backend" {
  source              = "./module/cicd/frontend_ssr"
  ssr_codebuild_name  = "backend-codebuild"  →  codebuild名
  ssr_buildspec       = "buildspec/development.yml"  → buildspec.ymlのパス
  ssr_artifact_bucket = "backend-s3-artifact"  →artifact名
  source_connection   = "arn:aws:codestar-connections:ap-northeast-1:700562912253:connection/57ae0d94-2208-4cca-958a-b20107698786"  →参考にして作成したarnを定義 https://docs.aws.amazon.com/ja_jp/codepipeline/latest/userguide/update-github-action-connections.html#connections-pipelines-github-action
  
  ssr_repo            = "fignny/reborn-api"  → cicdを行うリポジトリ名
  ssr_branch          = "master"  →  ブランチ
  ssr_ecr_name        = "dev-reborn-api"  → ecrの名前

  nginx_buildspec       = "containers/nginx/buildspec.yml"  → nginxのbuildspec.ymlのパス
  nginx_source_location = "https://github.com/fignny/reborn-api.git"  →↑のbuildspec.ymlのあるリポジトリ(cicdを行うリポジトリ名と同じ)
  nginx_push_branch     = "main"  →ブランチ
  nginx_codebuild_name  = "nginx_codebuild"  → codebuildの名前
  nginx_ecr_name        = "web-backend-nginx"  → ecrの名前
  
  github_token = "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"  → 自分のgithubアカウントでtokenを発行する必要がある
  
  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
  image_file   = "imagedifinitions.json"  → 固定でこの名前で問題ない
}

#frontend用(spa_cloudfront)cicd
module "cicd_frontend_spa" {
  source = "./module/cicd/frontend_spa"
  spa_codebuild_name  = "backend-codebuild"
  spa_buildspec       = "buildspec/development.yml"
  spa_artifact_bucket = "backend-s3-artifact"
  source_connection       = "arn:aws:codestar-connections:ap-northeast-1:700562912253:connection/57ae0d94-2208-4cca-958a-b20107698786"
  spa_repo            = "fignny/reborn-api"
  spa_branch          = "master"
  spa_ecr_name        = "dev-reborn-api"
}

#backend用cicd
module "cicd_backend" {
  source                  = "./module/cicd/backend"
  bakcend_codebuild_name  = "backend-codebuild"
  backend_buildspec       = "buildspec/development.yml"
  backend_artifact_bucket = "backend-s3-artifact"
  source_connection       = "arn:aws:codestar-connections:ap-northeast-1:700562912253:connection/57ae0d94-2208-4cca-958a-b20107698786"
  backend_repo            = "fignny/reborn-api"
  backend_branch          = "master"
  backend_ecr_name        = "dev-reborn-api"

  nginx_buildspec       = "containers/nginx/buildspec.yml"
  nginx_source_location = "https://github.com/fignny/reborn-api.git"
  nginx_push_branch     = "master"
  nginx_codebuild_name  = "nginx_codebuild"
  nginx_ecr_name        = "web-backend-nginx"

  github_token = "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"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
  image_file   = "imagedifinitions.json"

}

#SPA用cloudfront
module "spa_cloudfront" {
  source              = "./module/spa_cloudfront"
  bucket_name         = "spa_cloudfront-bucket-afasfeegg"  → spaホスティング用のs3名
  acl                 = "private"  →  cloudfrontをかませるのでprivate
  domain_name         = "testrote.worker.cafe"  spaでアクセスするためのドメイン
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
  acm_certificate_domain_name = "testrote.worker.cafe"  →  acmで取得するドメインネーム
  zone_id                     = "ZGVBT55SBZLNB"  →ホストゾーンのid
  route53_record_name         = "testrote"
  providers = {
    aws = aws.east
  }
}

```


