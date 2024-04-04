variable "cluster_name" {
  description = "The name of the EKS cluster - used for identifying network aspects with tags"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to place the cluster id"
  type        = string
}

variable "private_subnets" {
  description = "Private Subnet IDs for the cluster"
  type        = list(string)
}

variable "security_group_ids" {
  type = list(string)
}