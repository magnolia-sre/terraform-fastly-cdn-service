terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.20"
    }
    fastly = {
      source = "fastly/fastly"
      version = "~> 5.6"
    }
  }
  required_version = "~> 1.0"
}