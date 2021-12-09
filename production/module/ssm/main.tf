resource "aws_ssm_parameter" "db_username" {
  name        = "/prod/db/username"
  type        = "String"
  value       = var.db_username
  description = "データーベースユーザー名"
}
resource "aws_ssm_parameter" "db_password" {
  name        = "/prod/db/password"
  type        = "String"
  value       = var.db_password
  description = "データーベースパスワード"
}
resource "aws_ssm_parameter" "db_port" {
  name        = "/prod/db/port"
  type        = "String"
  value       = var.db_port
  description = "データーベースポート"
}
resource "aws_ssm_parameter" "db_host" {
  name  = "/prod/db/host"
  type  = "String"
  value = replace(var.db_endpoint, ":3306", "")

  description = "データーベースホスト"
}
resource "aws_ssm_parameter" "db_database" {
  name        = "/prod/db/database"
  type        = "String"
  value       = var.db_name
  description = "データーベース名"
}

resource "aws_ssm_parameter" "db_engine" {
  name        = "/prod/db/engine"
  type        = "String"
  value       = "django.db.backends.mysql"
  description = "dbエンジン"
}

resource "aws_ssm_parameter" "django_secret" {
  name        = "/prod/django/secret"
  type        = "String"
  value       = "8KjZ3gBH4gvfP|uJ,+0H/Jj/u4ebThhAJLC!TnC2+Cn%|b7_p.CVQAi5W|v+9wJ4,zusG7eKLU5z/5uV+&F2"
  description = "djangoシークレットキー"
}

resource "aws_ssm_parameter" "cors_origin_allow_all" {
  name        = "/prod/django/cors"
  type        = "String"
  value       = "True"
  description = "cors"
}

resource "aws_ssm_parameter" "ses_host" {
  name        = "/prod/django/ses_host"
  type        = "String"
  value       = "email-smtp.ap-northeast-1.amazonaws.com"
  description = "sesのホスト名"
}

resource "aws_ssm_parameter" "ses_port" {
  name        = "/prod/django/ses_port"
  type        = "String"
  value       = "587"
  description = "sesのポート名"
}

resource "aws_ssm_parameter" "ses_secure" {
  name        = "/prod/django/ses_secure"
  type        = "String"
  value       = "False"
  description = "sesのセキュリティ"
}

resource "aws_ssm_parameter" "ses_auth_user" {
  name        = "/prod/django/ses_auth_user"
  type        = "String"
  value       = "AKIASS36XFYJTJME6HJU"
  description = "ses認証済みユーザー"
}

resource "aws_ssm_parameter" "ses_auth_password" {
  name        = "/prod/django/ses_auth_password"
  type        = "String"
  value       = "BBd/jaE2E9DcQA/n/arjTzfo3RqTPHjt0tuydBUBeemn"
  description = "ses認証済みユーザーパスワード"
}

resource "aws_ssm_parameter" "ses_reject" {
  name        = "/prod/django/ses_reject"
  type        = "String"
  value       = "False"
  description = "sesリジェクト認証"
}

resource "aws_ssm_parameter" "ses_maila" {
  name        = "/prod/django/ses_maila"
  type        = "String"
  value       = "noreply@pro-cloud.co.jp"
  description = "sesメーラー"
}

resource "aws_ssm_parameter" "bucket_name" {
  name        = "/prod/django/bucket_name"
  type        = "String"
  value       = "reborn-prod-image-20211130"
  description = "バケットネーム"
}

resource "aws_ssm_parameter" "s3_access_key" {
  name        = "/prod/django/s3_access_key"
  type        = "String"
  value       = "AKIASS36XFYJVKGIHCU3"
  description = "s3のアクセスキー"
}

resource "aws_ssm_parameter" "secret_key" {
  name        = "/prod/django/secret_key"
  type        = "String"
  value       = "yi6wPkJ58iZszl6Ns83Bg4BeZ6kO/lM+/O8awuw5"
  description = "s3のシークレットキー"
}

resource "aws_ssm_parameter" "debug" {
  name        = "/prod/django/debug"
  type        = "String"
  value       = "True"
  description = "djangoデバック許可"
}

resource "aws_ssm_parameter" "dn" {
  name        = "/prod/django/dn"
  type        = "String"
  value       = "https://dev.pro-cloud.co.jp/"
  description = "ドメインネーム"
}

resource "aws_ssm_parameter" "cf" {
  name        = "/prod/django/cf"
  type        = "String"
  value       = "d2h3qaoavbgs54.cloudfront.net"
  description = "クラウドフロントドメイン"
}