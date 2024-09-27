terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }

  required_version = ">= 1.6"
}

provider "aws" {
  region = "eu-north-1"
}