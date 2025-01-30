terraform {
  backend "s3" {
    bucket = "s3-backend-b4-bucket"
    region = "us-east-1"
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
  #access_key = "YOUR-ACCESS-KEY"
  #secret_key = "YOUR-SECRET-KEY"
}

resource "aws_instance" "web" {
  ami = "ami-0ac4dfaf1c5c0cce9"
  instance_type = "t3.micro"
  key_name = "server-key"
  vpc_security_group_ids = ["sg-0ef0726f3c7819b49"]
  tags = {
    Name = "web-server"
  }
}