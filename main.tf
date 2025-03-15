terraform {
    backend "remote" {
        organization = "rednaxela"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
          name = "dev-workflow"
        }
      }
    

      # You need to specify required providers block
      required_providers {
        null = {
          source = "hashicorp/null"
          version = "~> 3.0"  # Specify a version constraint
        }
      }
    }

    # An example resource that does nothing.
    resource "null_resource" "example" {
      triggers = {
        value = "A example resource that does nothing!"
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
    }

    

    tags = {
        Name = "Github-Actions-Test"
    }
    
    

