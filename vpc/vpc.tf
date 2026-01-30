data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Logic to determine if tiers should exist
  enable_private        = var.number_of_layer >= 2
  enable_isolated       = var.number_of_layer == 3
  enabled_dedicated_eip = var.dedicated_eip_for_nat >= 1
  enabled_dedicated_nat = var.dedicated_eip_for_nat >= 1 || local.enabled_dedicated_nat
  creation_method       = "Terraform"

  available_az_count = length(data.aws_availability_zones.available.names)
  max_azs_to_use     = 3
  selected_azs = slice(
    data.aws_availability_zones.available.names,
    0,
    min(local.available_az_count, local.max_azs_to_use)
  )
}


resource "aws_vpc" "vpc" {
  cidr_block = var.original_cidr
  tags = {
    "Name"    = "${var.group_name}-vpc"
    "Managed" = local.creation_method
  }
}

# omitted all rule of the default sg
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnets" {
  count             = var.number_of_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.original_cidr, 8, count.index)
  availability_zone = element(local.selected_azs, count.index)
  tags = {
    "Name"    = "${var.group_name}-pub-subnet-00${count.index + 1}"
    "Managed" = local.creation_method
    "Type"    = "public"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = local.enable_private ? var.number_of_subnets : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.original_cidr, 8, count.index + 10)
  availability_zone = element(local.selected_azs, count.index)
  tags = {
    "Name"    = "${var.group_name}-pri-subnet-00${count.index + 1}"
    "Managed" = local.creation_method
    "Type"    = "private"
  }
}

resource "aws_subnet" "isolated_private_subnets" {
  count             = local.enable_isolated ? var.number_of_subnets : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.original_cidr, 8, count.index + 20)
  availability_zone = element(local.selected_azs, count.index)
  tags = {
    "Name"    = "${var.group_name}-db-subnet-00${count.index + 1}"
    "Managed" = local.creation_method
    "Type"    = "isolated"
  }
}

resource "aws_internet_gateway" "main_public_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"    = "${var.group_name}-main-igw"
    "Managed" = local.creation_method
    "Type"    = "public"
  }
}

resource "aws_route_table" "default_main_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"    = "${var.group_name}-main-route-table"
    "Managed" = local.creation_method
    "Type"    = "public"
  }
}

resource "aws_route" "internet_allowance_route" {
  route_table_id         = aws_route_table.default_main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_public_igw.id
}

resource "aws_route_table_association" "pub_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.default_main_route_table.id
}

resource "aws_eip" "nat_eip" {
  count  = local.enabled_dedicated_eip ? 1 : 0
  domain = "vpc"
  tags = {
    "Name"    = "${var.group_name}-nat-eip"
    "Managed" = local.creation_method
    "Type"    = "public"
  }
}

resource "aws_nat_gateway" "main_nat" {
  count         = local.enabled_dedicated_nat ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    "Name"    = "${var.group_name}-nat-gateway"
    "Managed" = local.creation_method
    "Type"    = "AWS"
  }

  depends_on = [aws_eip.nat_eip]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"    = "${var.group_name}-pri-route-table"
    "Managed" = local.creation_method
    "Type"    = "private"
  }
}

resource "aws_route" "private_internet_route" {
  count                  = local.enabled_dedicated_nat ? 1 : 0
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.main_nat[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
