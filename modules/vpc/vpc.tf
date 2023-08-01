data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "172.0.0.0/19"
  availability_zone = var.availability_zone_a
  tags = {
    Name                              = "subred1_david"
    "kubernetes.io/role/internal-elb" = var.eks_link_private_internal_elb
    "kubernetes.io/cluster/eks"       = var.name_eks
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = var.vpc_id
  cidr_block        = "172.0.32.0/19"
  availability_zone = var.availability_zone_b
  tags = {
    Name                              = "subred2_david"
    "kubernetes.io/role/internal-elb" = var.eks_link_private_internal_elb
    "kubernetes.io/cluster/eks"       = var.name_eks
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    "Name"                      = "subred3_david"
    "kubernetes.io/role/elb"    = var.eks_link_public_elb
    "kubernetes.io/cluster/eks" = var.name_eks
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    "Name"                      = "subred4_david"
    "kubernetes.io/role/elb"    = var.eks_link_public_elb
    "kubernetes.io/cluster/eks" = var.name_eks
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "nat_david"
  }
}

resource "aws_nat_gateway" "gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "gateway_david"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gateway.id
  }

  tags = {
    Name = "private_route_david"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_route_david"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.public.id
}

