resource "aws_ssm_parameter" "db_username" {
  name        = "/dev/db/username"
  type        = "String"
  value       = var.db_username
  description = "データーベースユーザー名"
}
resource "aws_ssm_parameter" "db_password" {
  name        = "/dev/db/password"
  type        = "String"
  value       = var.db_password
  description = "データーベースパスワード"
}
resource "aws_ssm_parameter" "db_port" {
  name        = "/dev/db/port"
  type        = "String"
  value       = var.db_port
  description = "データーベースポート"
}
resource "aws_ssm_parameter" "db_host" {
  name  = "/dev/db/host"
  type  = "String"
  value = replace(var.db_endpoint, ":3306", "")
  description = "データーベースホスト"
}
resource "aws_ssm_parameter" "db_database" {
  name        = "/dev/db/database"
  type        = "String"
  value       = var.db_name
  description = "データーベース名"
}

resource "aws_ssm_parameter" "db_root_password" {
  name        = "/dev/db/rootpassword"
  type        = "String"
  value       = "root"
  description = "データーベースルートパスワード"
}

resource "aws_ssm_parameter" "server_addr" {
  name        = "/dev/rust/server_addr"
  type        = "String"
  value       = "0.0.0.0:8088"
  description = "サーバーアドレス"
}

resource "aws_ssm_parameter" "database_url" {
  name        = "/dev/db/database_url"
  type        = "String"
  value       = "mysql://${var.db_username}:${var.db_password}@${replace(var.db_endpoint, ":3306", "")}:${var.db_port}/${var.db_name}"
  description = "データベースURL"
}

resource "aws_ssm_parameter" "aws_access_key" {
  name        = "/dev/rust/aws_access_key"
  type        = "String"
  value       = "AKIAYVBQ55NA33LVLDM3"
  description = "AWSアクセスキー"
}

resource "aws_ssm_parameter" "aws_secret_key" {
  name        = "/dev/rust/aws_secret_key"
  type        = "String"
  value       = "PYcMlqMZ4vPE3ALHpu9k9x7Nt+UaaVRhasXgTTtd"
  description = "AWSシークレットキー"
}

resource "aws_ssm_parameter" "aws_region" {
  name        = "/dev/rust/aws_region"
  type        = "String"
  value       = "ap-northeast-1"
  description = "AWSリージョン"
}

resource "aws_ssm_parameter" "aws_bucket_name" {
  name        = "/dev/rust/aws_bucket_name"
  type        = "String"
  value       = "dev-mitsuibau-bucket"
  description = "s3バケット"
}

resource "aws_ssm_parameter" "azure_access_token" {
  name        = "/dev/rust/azure_access_token"
  type        = "String"
  value       = "eyJ0eXAiOiJKV1QiLCJub25jZSI6IjljR0ZPazVKQzlDZGJUNlp2S1Z1V2hzQ1RpQUJzT0xHLU9KWE5NeVEzV1UiLCJhbGciOiJSUzI1NiIsIng1dCI6Imwzc1EtNTBjQ0g0eEJWWkxIVEd3blNSNzY4MCIsImtpZCI6Imwzc1EtNTBjQ0g0eEJWWkxIVEd3blNSNzY4MCJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9hN2FjZDFlZS03MTk3LTQ1Y2ItODExMC01NGNiMzQ2NGRmNzkvIiwiaWF0IjoxNjMxNzg2MjUyLCJuYmYiOjE2MzE3ODYyNTIsImV4cCI6MTYzMTc5MDE1MiwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFVUUF1LzhUQUFBQWRWTU1FTGMxMkxvRVFHVWRKbnZ0M3JOdnRSQlhwT3lLM0RxMm05amVjSmlGS2M5bi85Q21yL0hXcVQ2d04vaGZCWC9pRlZsUjQrMUltZFFqcUpHRzR3PT0iLCJhbHRzZWNpZCI6IjE6bGl2ZS5jb206MDAwM0JGRkQ0MTA1OUUyMiIsImFtciI6WyJwd2QiXSwiYXBwX2Rpc3BsYXluYW1lIjoiZ3JhcGggYXBwIiwiYXBwaWQiOiJkMjNlYWZlOS1hNjZmLTRlNjktYmYzNy05OTU3YTYyZDA0MzIiLCJhcHBpZGFjciI6IjEiLCJlbWFpbCI6ImljaGkudGVzdDIxN0BnbWFpbC5jb20iLCJmYW1pbHlfbmFtZSI6IkJhbmdhc2UiLCJnaXZlbl9uYW1lIjoiVGVzdCIsImlkcCI6ImxpdmUuY29tIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiMTE2LjY1LjE5NS4xNjIiLCJuYW1lIjoiQmFuZ2FzZSBUZXN0Iiwib2lkIjoiNDA5ZDk1NDYtYWJmZi00N2Y3LWJlYmEtODdkMWZhM2IzYWU5IiwicGxhdGYiOiI1IiwicHVpZCI6IjEwMDMyMDAxODI5QThGRTQiLCJyaCI6IjAuQVdRQTd0R3NwNWR4eTBXQkVGVExOR1RmZWVtdlB0SnZwbWxPdnplWlY2WXRCREprQUkwLiIsInNjcCI6IkNoYW5uZWxNZXNzYWdlLlNlbmQgVGVhbXNBcHAuUmVhZFdyaXRlLkFsbCBVc2VyLlJlYWQgcHJvZmlsZSBvcGVuaWQgZW1haWwiLCJzaWduaW5fc3RhdGUiOlsia21zaSJdLCJzdWIiOiI4b19MSDltQVlTR2ItbXVjakgzQXBXM0FSR0VNc1ZkRk41dFQ2bFBYbWQ0IiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkFTIiwidGlkIjoiYTdhY2QxZWUtNzE5Ny00NWNiLTgxMTAtNTRjYjM0NjRkZjc5IiwidW5pcXVlX25hbWUiOiJsaXZlLmNvbSNpY2hpLnRlc3QyMTdAZ21haWwuY29tIiwidXRpIjoiaEd0aXVzdF9pRS1TTTY2NldORW9BQSIsInZlciI6IjEuMCIsIndpZHMiOlsiNjJlOTAzOTQtNjlmNS00MjM3LTkxOTAtMDEyMTc3MTQ1ZTEwIiwiYjc5ZmJmNGQtM2VmOS00Njg5LTgxNDMtNzZiMTk0ZTg1NTA5Il0sInhtc19zdCI6eyJzdWIiOiJkZ1QxWHhLYnRIeWhVbHhrajZ4dThuNHNFdHZnbV9XN2pmd3JXcURFVzhNIn0sInhtc190Y2R0IjoxNjMxNjA0ODQzfQ.pLSULudQ3X-q2SK3d5aob-uiGTaCXK1_b75ntHcR3ffyQZTDsp_QH9Pgcz4xTitaEw95XS6u8hgTt_5JB-SADFlvEFsD8H9DNwNkts1a21WdysR2_QiOuzjYmwotrV_etXzY73_4Ar8W-CUgOgfak2pzUH9g-CDjXZrk0pRXAPl-mNDPUbUwsd4Web6zHNcrPVyhHAAYHJ0yGJUnaH6Qc9zF0qQt1Vi4rOi_Z3miOdxtRSvSrtWtKrCYmeCtoRehTGKG0MjLCsU51rKIJvM_12COnh5rSkfx1nFw1Rpd198FG-qFA4-Uwo8LFriaT9g9BFsXeZURIkT_JlSzgpAphA"
  description = "azureアクセストークン"
}

resource "aws_ssm_parameter" "azure_reflesh_token" {
  name        = "/dev/rust/azure_reflesh_token"
  type        = "String"
  value       = "0.AWQA7tGsp5dxy0WBEFTLNGTfeemvPtJvpmlOvzeZV6YtBDJkAI0.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P868HG71IZUJmzgzgwwO7ADdlt6cgVQwM9W-VV5011Fc-SR4li9EBmfhRlbCt--3AgEV-LUQF9PdGLd68J6k1m8HVp-4komZ2k3zB-GMBgheTUDcJpbjvDJqfsIzeOtVoUm-fRfJPEkt8k47SJz8VRIo9XjH6mvpwRnRpFnNuiBNHCrGHXCBqA6lYo0cAbKQbtSfB8NWcllyUNClgdnMOVrfNlvR3I1O9jJbaiJggZNgG1nYfY9uB43ZigvrxZSszeREhj3WSI3Ty7vz8yNf3dE3CvNgmL4DXzah2my6elmE6evCwVwYr1gy9sUl1JPotHLGz00s6Pg_7fZkzIPPR_rWmIM1Cumf44I3ZLH1FSkr39E54rpqxYDpKV6EzRaEHPhYsDtk2cFQXUcu96QRKIhfeyCZwgiGcDVD12araHhF6DBoWAo8bksFDMDSEV6VxIjgMg1T09KQrEVUMszc5dRDOajmehos-l_uUTFqfxuTdfiUBkUcbTcAmQMYeVrC8wueJipuLXLjNmbKSoCWDp7MNSA-ac85mq0hw23-o4dUoaI7Z3x_tZg2sVlqlssU5alA8EpTQd78JuVhEPUk3aMfa17XCXjAwoqk75EmId-lYG9IVsHQ2M1Qvohz3OPINgpC3Fw-nNN9pUo3ucKRMeT3RBnYAT93BT3OrRuWPBeI5FRm-6gcYiAnND5sFvwSLwKCZDzqQSH49L0ILREheHMpx_YODXmzlvyRE0T3wlZERTrE_iw7Lu_hM14AgXdhzgXXOe2Fv9NikTiXtz4EzxS4SIiL7qbobg5TLPLqcAWPkSMMIOUeZrheVF6ynJo-iEJ8mP0iAH_c1AcD5XccFaG_G4ZKldnkKsRJ5goQtXKRJ48I9ot7luguy3z9jwhWj4sJ-jtevjAHVnXL4Omk78w5LAkRIRfL7ypYz8zcy6vNutstzYvVPqw1zfJvll0edc1J4u1UAV_JbwohNT4jV3i9hVyQ0mq65B7swq6YTde4fXQIuOyOvcu0pDW_P1exc3xEQo4HfqQ9uAk6v-ZsSe1XPADRKkyvNLGudHN-nzOIuIunxzhHMOX7WbhpuWfPH8k9DTfGGPIauHMysmn5UckU-CcqeFW7UC1QneTSGjvv5pjNhj7_hyIw9k_MvDKj3Gx8Stu7T2J_ghmZ8cobzgFbyNxqnurvl3ddCMQ8ymcgG9okE6T72TA3SgrCmpc1a5X6gskUD6qswtirvolt0EwDgzqUGnHs1TBz6Kf2jYG4S3W41j62tLYg-Efi_Q6OLFro58dlhpUZHFFaZ_APAslewUrDySVViXD_sAuvRHSCf85sQ1KA7SA8cSPTA16iV0mPZ8dYopEKBDsxXoaa3l-mohUXvx451jrR0a23D1ZSOtKV-0Ufn3an4o6n78aQS35Z6FxdLw4ZRmxY_LXPNC1ni5UoiUAGC4TUXv5LB9LsUz-OA8c3Bv32-H9ssRqBqgJA4m69mH57S67m6pPMAwXkJCzbMZef8h6icIY2MhD5Q"
  description = "azureリフレッシュトークン"
}

resource "aws_ssm_parameter" "cf" {
  name        = "/dev/rust/cf"
  type        = "String"
  value       ="d2d6n4x137ve73.cloudfront.net"
  description = "cloudfrontドメイン"
}
