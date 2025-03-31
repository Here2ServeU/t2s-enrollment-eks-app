resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "t2s-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

