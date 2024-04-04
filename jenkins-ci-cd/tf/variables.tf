variable "primary_region" {
  description = "The Region To Create The Resources In."
  type        = string
}

variable "secondary_region" {
  description = "The Region To Create The Resources In."
  type        = string
}

# IAM VARS
variable "iam_role_jenkins_name" {
  description = "IAM Role Name For Jenkins."
  type        = string
}

variable "iam_role_node_group_name" {
  description = "IAM Role Name For Node Group."
  type        = string
}

# VPC VARS
variable "vpc_name" {
  description = "VPC Name For EKS Cluster."
  type        = string
}

variable "vpc_public_subnet_ids" {
  description = "Public Subnet IDs For EKS Cluster."
  type        = list(string)
}

variable "vpc_private_subnet_ids" {
  description = "Private Subnet IDs For EKS Cluster."
  type        = list(string)
}

variable "vpc_availability_zones" {
  description = "Availability Zones For EKS Cluster."
  type        = list(string)
}

# EC2 VARS
variable "ec2_name" {
  description = "EC2 Name For EKS Cluster."
  type        = string
}

variable "ec2_key_pair_name" {
  description = "EC2 Key Pair Name For EC2 Instance."
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type For EC2 Instance."
  type        = string
}

variable "ec2_ami_type" {
  description = "EC2 AMI Type For EC2 Instance."
  type        = string
}

# RDS VARS
variable "rds_db_name" {
  type = string
}

variable "rds_db_identifier" {
  type = string
}

variable "rds_db_instance_class" {
  type = string
}

variable "rds_db_engine" {
  type = string
}

variable "rds_db_engine_version" {
  type = string
}

variable "rds_db_family" {
  type = string
}

variable "rds_db_allocated_storage" {
  type = number
}

variable "rds_db_creds" {
  type = string
}

# Security VARS
variable "security_group_name" {
  description = "Security Group Name For EKS Cluster."
  type        = string
}

variable "security_group_cidr_block_0" {
  description = "0.0.0.0/0 CIDR Block For Security Group."
  type        = string
}

variable "security_group_cidr_block_16" {
  description = "10.0.0.0/16 CIDR Block For Security Group."
  type        = string
}

variable "security_group_protocol" {
  description = "Protocol For Security Group."
  type        = string
}

variable "security_group_app_port" {
  description = "App Port For Security Group."
  type        = list(number)
}

variable "security_group_ssh_port" {
  description = "SSH Port For Security Group."
  type        = number
}

variable "security_group_database_port" {
  description = "Database Port For Security Group."
  type        = number
}

# EKS VARS
variable "eks_cluster_name" {
  description = "Cluster Name For EKS."
  type        = string
}

variable "eks_node_group_name" {
  description = "Node Group Name For EKS."
  type        = string
}
