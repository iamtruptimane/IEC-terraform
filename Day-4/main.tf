terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "terraform-backend-b5-bucket"
    key = "terraform.tfstate"
  }
}
provider "aws" {
  region = var.region
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project}-vpc"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.public_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.project}-public-subnet"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.private_cidr
  availability_zone = var.az2
  tags = {
    Name = "${var.project}-private-subnet"
  }
}
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "${var.project}-IGW"
  }
}
resource "aws_default_route_table" "main-rt" {
  default_route_table_id = aws_vpc.my-vpc.default_route_table_id
  tags = {
    Name = "${var.project}-main-rt"
  }
}
resource "aws_route" "main-route" {
  route_table_id = aws_default_route_table.main-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}
resource "aws_security_group" "my-sg" {
  name = "${var.project}-sg"
  description = "allow ssh, http, https traffic"
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    protocol = "TCP"
    from_port = "80"
    to_port = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "TCP"
    from_port = "22"
    to_port = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "TCP"
    from_port = "443"
    to_port = "443"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [ aws_vpc.my-vpc ]
}
resource "aws_instance" "public-server" {
  subnet_id = aws_subnet.public_subnet.id
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  availability_zone = var.az1
  tags = {
    Name = "${var.project}-public-server"
  }
  depends_on = [ aws_security_group.my-sg ]
}
resource "aws_instance" "private-server" {
  subnet_id = aws_subnet.private_subnet.id
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  availability_zone = var.az2
  tags = {
    Name = "${var.project}-private-server"
  }
  depends_on = [ aws_security_group.my-sg ]
}


