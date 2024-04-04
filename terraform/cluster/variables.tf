variable "region" {
  description = "The Region To Create The Resources In."
  type        = string
  default     = "eu-west-2"
}

# VPC VARS
variable "vpc_name" {
  description = "The Name Of The VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR For The VPC."
  type        = string
}

variable "public_subnets" {
  description = "A List Of Public Subnet CIDRs."
  type        = list(string)
}

variable "private_subnets" {
  description = "A List Of Private Subnet CIDRs."
  type        = list(string)
}

variable "availability_zones" {
  description = "A List Of Availability Zones In The Region."
  type        = list(string)
}
# ecr
variable "ecr_repo_name" {
  description = "name of ecr repo"
  type = string
}
variable "ecr_force_destroy" {
  description = "force destroy ecr boolean"
  type = bool
}

# eks
variable "cluster_name" {
  description = "name of the eks cluster"
  type = string
}
