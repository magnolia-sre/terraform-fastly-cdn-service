terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.44"
    }
    fastly = {
      source = "fastly/fastly"
      version = "~> 5.7"
    }
  }
  required_version = "~> 1.0"
}