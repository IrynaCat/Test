#create VPC
resource "aws_vpc" "vpc_test" {
  cidr_block       = "192.168.0.0/26"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames=true

  tags = {
    Name = "vps_test"
  }
}

#list avaliable zones
data "aws_availability_zones" "available" {
  state = "available"
}

#create subnets
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_test.id
  cidr_block = "192.168.0.0/28"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_test.id
  cidr_block = "192.168.0.16/28"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "public_subnet_avz" {
  vpc_id     = aws_vpc.vpc_test.id
  cidr_block = "192.168.0.32/28"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public_subnet"
  }
}

#create gateways
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_test.id

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_eip" "elastic_ip_address" {
  vpc = true
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "elastic_ip_address"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip_address.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "NAT gateway"
  }
}

#create routing table
resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc_test.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "route_table_private"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route_table_public"
  }
}

#associaation routetables and subnets
resource "aws_route_table_association" "association_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "association_private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "association_public_avz" {
  subnet_id      = aws_subnet.public_subnet_avz.id
  route_table_id = aws_route_table.route_table_public.id
}

#associaation VPC routetable and subnet
resource "aws_main_route_table_association" "association_main" {
  vpc_id = aws_vpc.vpc_test.id
  route_table_id = aws_route_table.route_table_public.id
}
#create security groups
resource "aws_security_group" "public_subnet_sgr" {
  name="public_subnet_sgr"
  description="Allow all connection from my ip"
  vpc_id=aws_vpc.vpc_test.id

  #  ingress {
  #   description = "Allow all"
  #   from_port   = 0
  #   to_port     = 0
  #   self      = true
  #   protocol    = "-1"
  #   cidr_blocks = ["31.148.149.249/32"]
  # }

  ingress {
    description = "Port App docker"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SHH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["31.148.149.249/32"]
  }

  egress {
    description="Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name="public_subnet_scgroup"
  }
}

resource "aws_security_group" "private_subnet_sgr" {
  name="private_subnet_sgr"
  description="Allow port 8080 and egress connections"
  vpc_id=aws_vpc.vpc_test.id

 ingress {
    description = "Port App docker"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description="Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name="private_subnet_scgroup"
  }
}

resource "aws_security_group_rule" "bastion_connect_ssh_sgr" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.public_subnet_sgr.id
  source_security_group_id = aws_security_group.private_subnet_sgr.id
}