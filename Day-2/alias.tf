#define alias fir deplying app in different region
provider "aws" {
  region = "us-east-1"
  alias = "us-east"
}
provider "aws" {
  region = "ap-south-1"
  alias = "ap-south"
}
resource "aws_instance" "web-east" {
  #to refer alias at resource block
  provider = aws.us-east
  ami = "ami-0ac4dfaf1c5c0cce9"
  instance_type = "t2.micro"
  key_name = "server-key"
  vpc_security_group_ids = ["sg-0ef0726f3c7819b49"]
  tags = {
    Name = "web-us-east-server"
  }
}
resource "aws_instance" "web-south" {
  #to refer alias at resource block
  provider = aws.ap-south
  ami = "ami-05fa46471b02db0ce"
  instance_type = "t2.micro"
  key_name = "mumbai-key"
  vpc_security_group_ids = ["sg-0d913411f0bf18322"]
  tags = {
    Name = "web-ap-south-server"
  }
}


