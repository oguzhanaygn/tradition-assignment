// Availability Zones

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zone_names = data.aws_availability_zones.available.names
}

// Local IP Address

data "http" "client-ip" {
  url = "http://ipv4.icanhazip.com"
}

// Subnet IDs

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  depends_on = [
        module.vpc, module.public-subnet-one, module.public-subnet-two, module.public-subnet-three
    ]
}

// Amazon Linux 2 AMI

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

// Bottle Rocket AMI

data "aws_ami" "bottlerocket-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.eks_cluster_version}-x86_64-*"]
  }
}