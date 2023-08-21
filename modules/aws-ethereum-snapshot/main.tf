terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.volume_size

  tags = {
    # Snapshot Enabled
    DailySnapshot = "true"
    Name          = var.snapshot_tag_name
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.aws-ethereum-snapshot.id
}

module "aws-ethereum-snapshot" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "ethereum-snapshot-${var.suffix}"

  ami               = data.aws_ami.amazon_linux.id
  availability_zone = var.availability_zone
  subnet_id         = var.subnet_id

  instance_type = var.instance_type

  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true
  user_data                   = file("scripts/ethereum-init.sh")

  enable_volume_tags = false
}
