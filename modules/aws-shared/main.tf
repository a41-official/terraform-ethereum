terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  cidr = var.vpc_cidr

  name            = "terraform-vpc"
  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
}

######## Default
resource "aws_security_group" "default" {
  name        = "sg_default"
  description = "Security group for default"
  vpc_id      = module.vpc.vpc_id

  // Outbound allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

######## Bastion Security group
resource "aws_security_group" "bastion" {
  name        = "sg_bastion"
  description = "Security group for bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr_blocks
  }
}

######## Monitoring Security Group
resource "aws_security_group" "monitoring" {
  name        = "sg_monitoring"
  description = "Security group for monitoring"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Monitoring from prometheus"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = var.monitoring_cidr_blocks
  }
}

######## Ethereum Security Group
resource "aws_security_group" "geth" {
  name        = "sg_geth"
  description = "Security group for Geth"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "Geth p2p TCP"
      from_port        = 30303
      to_port          = 30303
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Geth p2p UDP"
      from_port        = 30303
      to_port          = 30303
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_security_group" "lighthouse" {
  name        = "sg_lighthouse"
  description = "Security group for Lighthouse"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "Lighthouse p2p TCP"
      from_port        = 9000
      to_port          = 9000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Lighthouse p2p UDP"
      from_port        = 9000
      to_port          = 9000
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
