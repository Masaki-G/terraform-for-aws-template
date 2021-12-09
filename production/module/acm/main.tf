resource "aws_acm_certificate" "certificate" {
  domain_name       = var.acm_certificate_domain_name
  validation_method = "DNS"
}
resource "aws_route53_record" "route53_record_acm" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_route53_record" "route53_record" {
  name    = var.route53_record_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    evaluate_target_health = false
    name                   = var.cloudfront_name
    zone_id                = var.cloudfront_id
  }
}