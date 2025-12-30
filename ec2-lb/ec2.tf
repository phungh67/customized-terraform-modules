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

resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami           = coalesce(var.default_ami_value, data.aws_ami.ubuntu.id)
  region        = "us-east-1"
  instance_type = "t3.micro"
  tags = {
    "Name" = "${var.group_name}-${count.index + 1}"
  }
}
