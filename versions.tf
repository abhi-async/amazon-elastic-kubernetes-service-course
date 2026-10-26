terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.83, < 7.0"
    }
  }

  # Remote state with locking - create the bucket first, then uncomment.
  # backend "s3" {
  #   bucket       = "my-tf-state-bucket"
  #   key          = "eks/demo-eks/terraform.tfstate"
  #   region       = "us-east-1"
  #   use_lockfile = true
  #   encrypt      = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}
