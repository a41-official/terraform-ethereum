provider "aws" {
  alias                    = "korea"
  region                   = "ap-northeast-2"
}

locals {
  ethereum_mainnet_snapshot_tag_name = "ethereum-mainnet"
}

module "aws-korea-shared" {
  source = "./modules/aws-shared"
  providers = {
    aws = aws.korea
  }
  
  dlm_lifecycle_role_arn = "put arn here"
  bastion_cidr_blocks = ["1.1.1.1/32"]
  monitoring_cidr_blocks = ["2.2.2.2/32"]
}

module "aws-korea-ethereum-snapshot" {
  source = "./modules/aws-ethereum-snapshot"
  providers = {
    aws = aws.korea
  }

  suffix            = "1"
  key_name          = "key1"
  availability_zone = element(module.aws-korea-shared.azs, 0)
  subnet_id         = element(module.aws-korea-shared.public_subnets, 0)
  vpc_security_group_ids = [
    module.aws-korea-shared.sg_default_id,
    module.aws-korea-shared.sg_bastion_id,
    module.aws-korea-shared.sg_monitoring_id,
    module.aws-korea-shared.sg_geth_id,
    module.aws-korea-shared.sg_lighthouse_id
  ]
  snapshot_tag_name      = local.ethereum_mainnet_snapshot_tag_name
}

module "aws-korea-lido-dr" {
  source = "./modules/aws-lido-dr"
  providers = {
    aws = aws.korea
  }

  count = 1

  suffix            = count.index
  key_name          = "key2"
  availability_zone = element(module.aws-korea-shared.azs, 0)
  subnet_id         = element(module.aws-korea-shared.public_subnets, 0)
  vpc_security_group_ids = [
    module.aws-korea-shared.sg_default_id,
    module.aws-korea-shared.sg_bastion_id,
    module.aws-korea-shared.sg_monitoring_id,
    module.aws-korea-shared.sg_geth_id,
    module.aws-korea-shared.sg_lighthouse_id
  ]
  snapshot_tag_name      = local.ethereum_mainnet_snapshot_tag_name
}