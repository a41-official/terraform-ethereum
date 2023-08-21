variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "bastion_cidr_blocks" {
  description = "cird blocks of Bastion Host"
  type        = set(string)
  default     = []
}

variable "monitoring_cidr_blocks" {
  description = "cird blocks of Monitoring"
  type        = set(string)
  default     = []
}

variable "dlm_lifecycle_role_arn" {
  description = "ARN of dlm lifecycle role"
  type        = string
  default     = ""
}
