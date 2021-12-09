output "public_subnet_1" {
  value = aws_subnet.public_1.id
}
output "public_subnet_2" {
  value = aws_subnet.public_2.id
}

output "private_subnet_1" {
  value = aws_subnet.private_1.id
}

output "private_subnet_2" {
  value = aws_subnet.private_2.id
}
output "nat_gateway" {
  value = aws_nat_gateway.nat_gateway_1.id
}

output "vpc" {
  value = module.vpc.id
}

