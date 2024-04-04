# VPC VARS
region             = "eu-west-2"
vpc_name           = "Final-Project-VPC"
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

ecr_repo_name = "ce-fp-ecr"
ecr_force_destroy = true

cluster_name = "email"
