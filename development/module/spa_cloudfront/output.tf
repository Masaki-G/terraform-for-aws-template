output "spa_cloudfront_id" {
  value = aws_cloudfront_distribution.example_spa_cloudfront.hosted_zone_id
}

output "spa_cloudfront_name" {
  value = aws_cloudfront_distribution.example_spa_cloudfront.domain_name
}