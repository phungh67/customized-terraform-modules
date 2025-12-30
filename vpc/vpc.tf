locals {
  # Logic to determine if tiers should exist
  enable_private  = var.number_of_layer >= 2
  enable_isolated = var.number_of_layer == 3
}

resource "aws_vpc" "vpc" {
  cidr_block = var.original_cidr
  tags = {
    "Name" = "Bar"
  }
}

resource "aws_subnet" "example" {
  count = var.number_of_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.original_cidr, 8, count.index * 10)
}