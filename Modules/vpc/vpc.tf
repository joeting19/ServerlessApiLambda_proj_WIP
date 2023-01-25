data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_blocks["vpc"]
    enable_dns_hostnames = true
    tags = { Name = var.vpc_name_tag[0]}
}

resource "aws_subnet" "pub-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_blocks["pub_sn1"]
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = { Name = var.vpc_name_tag[1]}
}

resource "aws_subnet" "pub-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_blocks["pub_sn2"]
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = { Name = var.vpc_name_tag[2]}
}

resource "aws_subnet" "priv-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_blocks["priv_sn1"]
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = { Name = var.vpc_name_tag[3]}
}

resource "aws_subnet" "priv-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_blocks["priv_sn2"]
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = { Name = var.vpc_name_tag[4]}
}

resource "aws_subnet" "priv-subnet-3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_blocks["priv_sn3"]
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = { Name = var.vpc_name_tag[5]}
}

resource "aws_subnet" "priv-subnet-4" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_blocks["priv_sn4"]
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = { Name = var.vpc_name_tag[6]}
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Internet-Gateway"
  }
}

resource "aws_route_table" "Public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "Pub-sub-1-ass" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.Public_route_table.id
}

resource "aws_route_table_association" "Pub-sub-2-ass" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.Public_route_table.id
}

resource "aws_eip" "ngw-eip" {
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id     = aws_subnet.pub-subnet-1.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "Private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "Priv-sub-1-ass" {
  subnet_id      = aws_subnet.priv-subnet-1.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_route_table_association" "Priv-sub-2-ass" {
  subnet_id      = aws_subnet.priv-subnet-2.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_route_table_association" "Priv-sub-3-ass" {
  subnet_id      = aws_subnet.priv-subnet-3.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_route_table_association" "Priv-sub-4-ass" {
  subnet_id      = aws_subnet.priv-subnet-4.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_default_network_acl" "default_network_acl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  subnet_ids             = [aws_subnet.pub-subnet-1.id, aws_subnet.pub-subnet-2.id, aws_subnet.priv-subnet-1.id, aws_subnet.priv-subnet-2.id, aws_subnet.priv-subnet-3.id, aws_subnet.priv-subnet-4.id]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "default-network-acl"
  }
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}