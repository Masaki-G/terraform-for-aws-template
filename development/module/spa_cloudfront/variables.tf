variable "bucket_name" {}
variable "acl" {}
variable "acm_certificate_arn" {}
variable "domain_name" {}
variable "sid" {}
variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}