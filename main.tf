terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # No need to specify profile or assume_role here
  # The credentials will be picked up from the environment
}

# A simple resource that does nothing
resource "null_resource" "example" {
  triggers = {
    value = "A simple resource that does nothing!"
  }
}

resource "random_id" "index" {
    byte_length = 2
}

locals {
    subnets_list = tolist(data.aws_subnets.the-subnets.ids)
    subnets_random_index = random_id.index.dec % length(data.aws_subnets.the-subnets.ids)
    instance_subnet_id = local.subnets_list[local.subnets_random_index]
}

resource "aws_instance" "linux_server" {
    ami = data.aws_ami.amazon-linux.id
    instance_type = "t2.micro"
    subnet_id = local.instance_subnet_id
    associate_public_ip_address = true
    key_name = "terraform-ec2"
    iam_instance_profile = "3HDAmazonSSMManagedInstanceCore"
    
    tags = {
      Name = "Github-Actions-Test"  # yes This will be the name shown in AWS Console
    }
}

    

    
    
    

