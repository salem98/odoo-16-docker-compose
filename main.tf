/*
  terraform {
    cloud {
      organization = "example-org-name"
      workspaces {
        name = "workspace-name"
      }
    }
  }
*/


data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Amazon's owner ID
}

resource "aws_instance" "example" {
  count         = 1  # This line creates 4 instances
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "wsl"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Instance-${count.index}"
  }
}
