![](https://img.shields.io/badge/terraform-0.15.2-blue)
![](https://img.shields.io/badge/aws-3.53.0-orange)
![](https://img.shields.io/badge/-TerraForm%20-232F3E.svg?logo=terraform&style=flat)

# template-terraform-for-aws
自分がよく使うaws構成をterraformで汎用的に作成しました。
- ECR、ECSのfargateによる管理不要なコンテナを実行するためのサーバー環境
- S3 + cloudfrontによるSPAでのホスト
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
  SPAのフロント構成で行うためのcloudfrontの証明書を作成している。
  
#alb
  Fargate上にアクセスするためのALBを定義、HTTPSアクセスを前提としていてHTTPの場合はHTTPSにリダイレクトしている。HTTPSのために証明書取得もしている。

#cicd
  3つディレクトリがある。policyはそれぞれのディレクトリで使うcodebuildとcodepipelineのpolicyを定義している。
  それ以外の2つのフォルダはフォルダ名通りのcicdを定義

#ecs
  Fargateでbackendを動かすために定義している

#iam
  iamの基盤を定義

#image_host
  画像や動画などを管理するs3 + cloudfront構成の定義。独自ドメインは取得しない

#rds
  backendで使用するrdsを定義(ｍysqlを想定)

#security_group
  セキュリティグループの基盤を定義

#spa_cloudfront
  SPAでs3の静的コンテンツをcloudfrontで配信する処理を定義

#ssm
  環境変数を定義(現在だとRDSの情報を格納している)

#subnet vpc
  subnetとvpcを定義
  
#backend_container_definitions.json
  fargateで使用するタスク定義ファイル


