# Create VPC
resource "aws_vpc" "pg-vpc1" {
  tags = {
    Name = format("%s-vpc-1", var.projectPrefix)
  }
  cidr_block           = "${var.vpc1_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "pg-vpc1-inside-az-a-subnet" {
  vpc_id                  = "${aws_vpc.pg-vpc1.id}"
  cidr_block              = "10.130.0.0/24"
  availability_zone       = format("%sa", var.aws_region)
}


resource "aws_subnet" "pg-vpc1-outside-az-a-subnet" {
  vpc_id                  = "${aws_vpc.pg-vpc1.id}"
  cidr_block              = "10.130.2.0/24"
  availability_zone       = format("%sa", var.aws_region)
}

resource "aws_subnet" "pg-vpc1-workload-az-a-subnet" {
  vpc_id                  = "${aws_vpc.pg-vpc1.id}"
  cidr_block              = "10.130.1.0/24"
  availability_zone       = format("%sa", var.aws_region)
}


resource "aws_subnet" "pg-vpc1-external-subnet" {
  vpc_id                  = "${aws_vpc.pg-vpc1.id}"
  cidr_block              = "10.130.254.0/24"
  availability_zone       = format("%sc", var.aws_region)
}

# Create permit all VPC security group
resource "aws_security_group" "pg-vpc1-allow-all-sg" {
  name        = format("pg-vpc1-allow-all-%s-1-sg", var.projectPrefix)
  vpc_id      = "${aws_vpc.pg-vpc1.id}"
  description = "inbound traffic"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "pg-vpc1-external-rt" {
  vpc_id = aws_vpc.pg-vpc1.id
  tags = {
    Name = "${var.projectPrefix}-vpc1-external-rt"
  }
}

resource "aws_internet_gateway" "pg-vpc1-igw" {
  vpc_id = aws_vpc.pg-vpc1.id
  tags = {
    Name = format("%s-vpc1-igw", var.projectPrefix)
  }
}

resource "aws_route" "pg-vpc1-external-rt" {
  route_table_id         = aws_route_table.pg-vpc1-external-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pg-vpc1-igw.id
}

resource "aws_route" "pg-vpc1-external-rt-pcx1" {
  route_table_id         = aws_route_table.pg-vpc1-external-rt.id
  destination_cidr_block = "10.131.2.0/24"
  gateway_id             = aws_vpc_peering_connection.peer-1-2.id
}

resource "aws_route" "pg-vpc1-external-rt-pcx2" {
  route_table_id         = aws_route_table.pg-vpc1-external-rt.id
  destination_cidr_block = "10.131.5.0/24"
  gateway_id             = aws_vpc_peering_connection.peer-1-2.id
}

resource "aws_route" "pg-vpc1-external-rt-pcx3" {
  route_table_id         = aws_route_table.pg-vpc1-external-rt.id
  destination_cidr_block = "10.131.8.0/24"
  gateway_id             = aws_vpc_peering_connection.peer-1-2.id
}


resource "aws_route_table_association" "pg-vpc1-external-association" {
  subnet_id      = aws_subnet.pg-vpc1-external-subnet.id
  route_table_id = aws_route_table.pg-vpc1-external-rt.id
}