module "vpc" {
  source = "../vpc"

  tag        = var.tag
  cidr_block = var.cidr_block
}


resource "aws_subnet" "public_1" {
  vpc_id                  = module.vpc.id
  cidr_block              = var.cidr_blocks_public_1
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1
  tags = {
    Name = var.tag_public_1
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = module.vpc.id
  cidr_block              = var.cidr_blocks_public_2
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_2
  tags = {
    Name = var.tag_public_2
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = module.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.id
}

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "route_table_public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "private_1" {
  vpc_id                  = module.vpc.id
  cidr_block              = var.cidr_blocks_private_1
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1
  tags = {
    Name = var.tag_private_1
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = module.vpc.id
  cidr_block              = var.cidr_blocks_private_2
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_2
  tags = {
    Name = var.tag_private_2
  }
}

resource "aws_eip" "eip_nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "eip_nat_gateway_2" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.eip_nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.example]
}


resource "aws_route_table" "route_table_private_1" {
  vpc_id = module.vpc.id
}

resource "aws_route_table" "route_table_private_2" {
  vpc_id = module.vpc.id
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.route_table_private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_2" {
  route_table_id         = aws_route_table.route_table_private_2.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.route_table_private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.route_table_private_2.id
}
