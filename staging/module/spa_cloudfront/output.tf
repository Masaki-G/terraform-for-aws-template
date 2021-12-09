output "spa_cloudfront_id" {
  value = aws_cloudfront_distribution.spa_cloudfront.hosted_zone_id
}

output "spa_cloudfront_name" {
  value = aws_cloudfront_distribution.spa_cloudfront.domain_name
}