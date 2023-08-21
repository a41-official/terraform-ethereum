output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public Subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private Subnets"
  value       = module.vpc.private_subnets
}

output "azs" {
  description = "Availability zones"
  value       = local.azs
}

output "sg_default_id" {
  description = "Security group ID for Default"
  value       = aws_security_group.default.id
}


output "sg_bastion_id" {
  description = "Security group ID for Bastion"
  value       = aws_security_group.bastion.id
}

output "sg_monitoring_id" {
  description = "Security group ID for Monitoring"
  value       = aws_security_group.monitoring.id
}

output "sg_geth_id" {
  description = "Security group ID for Geth"
  value       = aws_security_group.geth.id
}

output "sg_lighthouse_id" {
  description = "Security group ID for Lighthouse"
  value       = aws_security_group.lighthouse.id
}