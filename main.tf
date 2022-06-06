# terraform setting block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# provider block
provider "aws" {
  region     = "ap-south-1"
  profile = "default" # $HOME/.aws/credentials
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
   Name = "instance-profile-test"
}

}

# Resouce block
resource "aws_security_group" "my-testing" {
  name        = "allow_port_8080"
  description = "Allow TLS inbound traffic"
 # vpc_id      = "vpc-01fa76e3fb69999b9"

  ingress {
    description      = "allow port 8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  }
resource "aws_security_group" "my-testing-1" {
  name        = "allow_port_80"
  description = "Allow TLS inbound traffic"
  # vpc_id      = "vpc-01fa76e3fb69999b9"

  ingress {
    description      = "allow port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  }
resource "aws_security_group" "my-ssh" {
  name        = "allow_ssh_port"
  description = "Allow TLS inbound traffic"
  #vpc_id      = "vpc-01fa76e3fb69999b9"

  ingress {
    description      = "allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  }

resource "aws_instance" "myec2-test" {
  ami           = "ami-079b5e5b3971bd10d"
  instance_type = "t2.micro"
  user_data = file("${path.module}/install.sh")
  key_name = "aws-devops4"
  vpc_security_group_ids = [ aws_security_group.my-testing.id,aws_security_group.my-testing-1.id,aws_security_group.my-ssh.id ]

  count = 3
  tags = {
    name = "devops4-${count.index}"
  }


}

