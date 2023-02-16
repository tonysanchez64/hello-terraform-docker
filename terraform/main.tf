terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

}


provider "aws" {

  region = "eu-west-1"
}

resource "aws_instance" "app_server" {

  ami           = "ami-0b752bf1df193a6c4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-0f3c5d809a2d46c67",
  ]
  subnet_id = "subnet-06425a67e3f5d820a"
  key_name  = "clave-lucatic"

  tags = {
    Name = var.instance_name
    APP  = "vue2048"
  }


}

