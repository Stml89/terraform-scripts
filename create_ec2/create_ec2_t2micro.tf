provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "terraform_instance" {
  ami                    = "<ami_id>"
  instance_type          = "t2.micro"
  key_name               = "<kay_name>"
  vpc_security_group_ids = ["<vpc_id>"]
  tags = {
    Name = "Terraform_Instance"
  }
}
