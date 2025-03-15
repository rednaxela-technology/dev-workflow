variable "vpc-Name" {
  type = string
  default = "poolicio.us-vpc"
}

data "aws_vpc" "the-vpc" {
  filter {
    name = "tag:Name"
    values = [var.vpc-Name]
  }
}

data "aws_subnets" "the-subnets" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.the-vpc.id]
  }
}

data "aws_subnet" "the-subnet" {
  for_each = toset(data.aws_subnets.the-subnets.ids)
  id = each.value
}

# Get latest Amazon Linux AMI
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.6.*.*-kernel-6.1-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "aws_access_key" {
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  sensitive   = true
}

