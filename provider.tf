# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.14"
    }
  }
}

