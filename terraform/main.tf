resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
  
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.key
  }

}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "MainIGW"
  }
  
}

resource "aws_security_group" "public_sg" {
  name        = "PublicSecurityGroup"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main-vpc.id
  tags = {
    Name = "PublicSecurityGroup"
  }  
}

resource "aws_vpc_security_group_egress_rule" "public_sg_egress" {
  security_group_id = aws_security_group.public_sg.id
  ip_protocol          = "-1"
  cidr_ipv4       = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_ingress" {
  security_group_id = aws_security_group.public_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTP traffic"
  
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_RT_assoc" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_route_table.id
  
}

resource "tls_private_key" "main_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
  
}

resource "aws_key_pair" "main_key_pair" {
  key_name   = "MainKeyPair"
  public_key = tls_private_key.main_key.public_key_openssh

  tags = {
    Name = "MainKeyPair"
  }
}

resource "local_file" "private_key" {
  content  = tls_private_key.main_key.private_key_pem
  filename = "${path.module}/main_key.pem"
}

resource "aws_instance" "servers" {
  for_each = var.app_servers
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet[each.value.subnet_key].id
  associate_public_ip_address = true
  key_name      = aws_key_pair.main_key_pair.key_name
  security_groups = [aws_security_group.public_sg.id]

  tags = {
    Name = each.key
  }
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}