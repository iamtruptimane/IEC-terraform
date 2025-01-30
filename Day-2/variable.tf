#explore variable block
provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  ami = "ami-0ac4dfaf1c5c0cce9"
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = ["sg-0ef0726f3c7819b49"]
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
