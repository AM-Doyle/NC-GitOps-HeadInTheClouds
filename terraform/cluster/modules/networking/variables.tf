variable "vpc_name" {
  description = "Name of the VPC to place cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster - used for identifying network aspects with tags"
  type        = string
}