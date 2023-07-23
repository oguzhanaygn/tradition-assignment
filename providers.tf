provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Purpose     = "Creating infrastructure resources via Terraform"
      Owner       = "DevOps Team"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}