resource "aws_s3_bucket" "example_image_bucket" {
  bucket = var.bucket_name
  acl    = var.acl
}

resource "aws_cloudfront_origin_access_identity" "hosting-cloudfront-identity" {}


resource "aws_cloudfront_distribution" "example_spa_cloudfront" {
  enabled = true
  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = aws_s3_bucket.example_image_bucket.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
  custom_error_response {
    error_code         = "403"
    response_code      = "200"
    response_page_path = "/index.html"
  }

  origin {
    domain_name = aws_s3_bucket.example_image_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.example_image_bucket.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.hosting-cloudfront-identity.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
  aliases = [var.domain_name]


}

data "aws_iam_policy_document" "example_policy" {
  statement {
    sid    = var.sid
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.hosting-cloudfront-identity.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.example_image_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  bucket = aws_s3_bucket.example_image_bucket.id
  policy = data.aws_iam_policy_document.example_policy.json
}
