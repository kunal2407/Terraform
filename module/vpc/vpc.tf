resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.project
   }
}

resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  tags = {
    Name = var.project
  }
}

resource "aws_subnet" "private_sub" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_cidr_block
  availability_zone  =  "ap-south-1b"
  tags = {
    Name = var.project
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.project
  }
}

resource "aws_route" "my_route" {
  route_table_id            = aws_vpc.my_vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.my_igw.id
}

resource "aws_eip" "my_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_sub.id

  tags = {
    Name = var.project
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
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_route_t.id
}


resource "aws_security_group" "my_security" {
  name        = "http"
  description = "Allow http"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "my_inbound" {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.from_port
  ip_protocol       = "tcp"
  to_port           = var.to_port

}

resource "aws_vpc_security_group_egress_rule" "my_outbound" {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535

}

output "subnet_id" {
 value = aws_subnet.public_sub.id
}

output "vpc_security_group_ids" {
 value = aws_security_group.my_security.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}