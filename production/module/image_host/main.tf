resource "aws_s3_bucket" "example_hosting_bucket" {
  bucket = var.bucket_name
  acl    = var.acl
}

resource "aws_cloudfront_origin_access_identity" "example_cloudfront_origin_access" {}


resource "aws_cloudfront_distribution" "example_clodfront" {
  enabled = true
  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = aws_s3_bucket.example_hosting_bucket.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.example_hosting_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.example_hosting_bucket.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example_cloudfront_origin_access.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_iam_policy_document" "example_policy" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.example_cloudfront_origin_access.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.example_hosting_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  bucket = aws_s3_bucket.example_hosting_bucket.id
  policy = data.aws_iam_policy_document.example_policy.json
}