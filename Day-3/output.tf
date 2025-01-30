terraform {
  backend "s3" {
    bucket = "s3-backend-b4-bucket"
    region = var.region
    key = "terraform.tfstate"
  }
}
provider "aws" {
  region = var.region
}
#explore data block -> manage resources which are already exist
data "aws_security_group" "aws-sg" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "group-name"
    values = ["web-sg"]
  }  
}

resource "aws_instance" "web" {
  ami = "ami-0ac4dfaf1c5c0cce9"
  instance_type = var.instance_type
  key_name = var.key_name
  #this ih how you can refer data block
  vpc_security_group_ids = [data.aws_security_group.aws-sg.id]
  tags = {
    Name = "web-server"
  }
}
variable "region" {
  description = "pass any region name"
  type = string
  default = "ap-south-1"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "key_name" {
  type = string
  default = "server-key"
}
variable "vpc_id" {
  default = "vpc-0cbbdb15bbcd7d653"
}
output "demo" {
  value = "hello world"
}
output "public-ip" {
  value = aws_instance.web.public_ip
}