provider "aws" {
    region = "ap-south-1"
}
resource "aws_vpc" "my_vpc" {
    cidr_block = "192.168.0.0/16"
    instance_tenancy = "default"
tags = {
    Name = "my-vpc"
    } 
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-sub"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "private-sub"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
tags = {
  name = "my-igw"
    }
}
resource "aws_route" "my_route" {
    route_table_id = aws_vpc.my_vpc.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw
}
resource "aws_eip" "my_eip" {
    domain = "vpc"
}
resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "my-nat"
  }
}
resource "aws_route_table" "private_route_t" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat.id
    }
}
resource "aws_route_table_association" "my_associat" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_t.id
}


resource "aws_instance" "demo_inst" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.my_security.id ]
  tags = {
    Name = "demo-inst"
  }
}
resource "aws_security_group" "my_security" {
  name        = "All-TCP"
  description = "Allow all ports"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "All-TCP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "my_inbound" {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 65535
  ip_protocol       = "tcp"
  
}
resource "aws_vpc_security_group_egress_rule" "my_outbound" {
    security_group_id = aws_security_group.my_security.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port = 0
    to_port = 65535
    ip_protocol = "tcp"
  
}

