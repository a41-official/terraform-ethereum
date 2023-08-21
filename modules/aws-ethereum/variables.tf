variable "suffix" {
  description = "A suffix to add to the instance name"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "A key name to associate with the instance"
  type        = string
  default     = ""
}

variable "snapshot_tag_name" {
  description = "Snapshot tag name"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "r6i.xlarge"
}

variable "volume_size" {
  description = "EBS volume size"
  type        = number
  default     = 1600
}