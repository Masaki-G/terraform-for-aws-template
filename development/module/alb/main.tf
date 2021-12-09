resource "aws_lb" "alb" {
  name                       = var.alb_name
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false

  subnets = [
    var.public_subnet_1,
    var.public_subnet_2
  ]

  security_groups = [
    aws_security_group.alb_sg.id
  ]
}
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

resource "aws_route53_record" "route53_record" {
  name    = var.recode_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
  }
}


resource "aws_acm_certificate" "certificate" {
  domain_name       = var.acm_certificate_domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "example_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = var.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.example_certificate : record.fqdn]
}

resource "aws_lb_target_group" "backend_target" {
  name                 = "backend-target"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/api/v1/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
  depends_on = [aws_lb.alb]

}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.certificate.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-1-2017-01"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ページが見つかりません"
      status_code  = "404"
    }
  }
}
resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "example_https" {

  listener_arn = aws_lb_listener.https.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

