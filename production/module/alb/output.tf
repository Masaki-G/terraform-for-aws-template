output "target_group" {
  value = aws_lb_target_group.backend_target.arn
}

output "id" {
  value = aws_lb.alb.id
}