locals {
  internet_ports = [443, 8080]
  ssh_ports      = 22

  # logical evaluation
  enable_bastion_host   = var.bastion_host > 0 && var.bastion_net != "" ? 1 : 0
  create_ssh_key_on_run = var.generated_new_ssh_key > 0 ? 1 : 0
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# some defaut rule for security group
resource "aws_security_group" "internet_allowance" {
  vpc_id      = var.vpc_id
  name        = "${var.group_name}-internet-allowance-sg"
  description = "Attach this group to allow outbound connection to the Internet"

  tags = {
    "Name" = "${var.group_name}-internet-allowance-sg"
  }
}

resource "aws_security_group" "public_bastion" {
  vpc_id      = var.vpc_id
  name        = "${var.group_name}-bastion-sg"
  description = "Allow bastion to be reached from public internet"
  tags = {
    "Name" = "${var.group_name}-bastion-sg"
  }
}

resource "aws_security_group" "main_machine" {
  vpc_id      = var.vpc_id
  name        = "${var.group_name}-base-machine-sg"
  description = "The main security group for machine, essential rules inculded"
  tags = {
    "Name" = "${var.group_name}-base-machine-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "internet_allowance_outbound" {
  count             = length(local.internet_ports)
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.internet_allowance.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = element(local.internet_ports, count.index)
  to_port           = element(local.internet_ports, count.index)
}

resource "aws_vpc_security_group_ingress_rule" "public_bastion_inbound" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.public_bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = local.ssh_ports
  to_port           = local.ssh_ports
}

resource "aws_vpc_security_group_egress_rule" "bastion_to_machine" {
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.public_bastion.id
  referenced_security_group_id = aws_security_group.main_machine.id
  from_port                    = local.ssh_ports
  to_port                      = local.ssh_ports
}

resource "aws_vpc_security_group_ingress_rule" "machine_ssh_from_bastion" {
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.main_machine.id
  referenced_security_group_id = aws_security_group.public_bastion.id
  from_port                    = local.ssh_ports
  to_port                      = local.ssh_ports
}

resource "aws_vpc_security_group_ingress_rule" "machine_web_server_inbound" {
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.main_machine.id
  from_port         = "80"
  to_port           = "80"
}

# ssh key

resource "tls_private_key" "ssh_key" {
  count     = local.create_ssh_key_on_run
  algorithm = var.key_alogrithm
  rsa_bits  = var.key_bits
}

resource "aws_key_pair" "common_key" {
  key_name   = "${var.group_name}-common-ssh-key"
  public_key = tls_private_key.ssh_key[count.index].public_key_openssh
}

# bastion first
resource "aws_instance" "ec2_bastion_host" {
  count                       = local.enable_bastion_host
  ami                         = var.default_ami_value != "" ? var.default_ami_value : data.aws_ami.ubuntu.id
  region                      = var.default_region
  instance_type               = var.instance_type
  subnet_id                   = var.bastion_net
  key_name                    = aws_key_pair.common_key.key_name
  associate_public_ip_address = true

  tags = {
    "Name" = "${var.group_name}-bastion-instance-${count.index + 1}"
  }

  lifecycle {
    precondition {
      condition     = var.bastion_host == 0 || (var.bastion_host > 0 && var.bastion_net != "")
      error_message = "Logic Error: You enabled bastion_host, but did not provide a valid bastion_net subnet ID."
    }
  }
}

resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami           = coalesce(var.default_ami_value, data.aws_ami.ubuntu.id)
  region        = var.default_region
  instance_type = "t3.micro"


  tags = {
    "Name" = "${var.group_name}-base-instance-${count.index + 1}"
  }

  lifecycle {
    precondition {
      condition     = var.generated_new_ssh_key > 0 || var.pre_created_ssh_key > 0
      error_message = "Security Lockout Risk: You must specify either generated_new_ssh_key or pre_created_ssh_key. Both cannot be 0."
    }
  }
}
