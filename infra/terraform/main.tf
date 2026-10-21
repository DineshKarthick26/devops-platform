provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name        = "${var.name}-vpc"
    environment = var.environment
    Managed_By  = "terraform"
  }
}