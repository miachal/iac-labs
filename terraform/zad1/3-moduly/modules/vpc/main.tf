terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}
