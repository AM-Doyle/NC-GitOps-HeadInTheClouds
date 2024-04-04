primary_region   = "eu-west-2"
secondary_region = "us-east-1"

# IAM VARS
iam_role_jenkins_name    = "hitc-role-jenkins"
iam_role_node_group_name = "hitc-role-ng"

# VPC VARS
vpc_name               = "hitc-vpc"
vpc_public_subnet_ids  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_private_subnet_ids = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
vpc_availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

# EC2 VARS
ec2_name          = "hitc-ec2"
ec2_key_pair_name = "hitc-key-pair"
ec2_instance_type = "t3.small"
ec2_ami_type      = "ami-0b9932f4918a00c4f"

# RDS VARS
rds_db_name              = "hitcDB"
rds_db_identifier        = "hitc-db"
rds_db_instance_class    = "db.t3.micro"
rds_db_engine            = "postgres"
rds_db_engine_version    = "15.5"
rds_db_family            = "postgres15"
rds_db_allocated_storage = 10
rds_db_creds             = "hitc-db-credentials"

# Security VARS
security_group_name          = "hitc-sg"
security_group_cidr_block_0  = "0.0.0.0/0"
security_group_cidr_block_16 = "10.0.0.0/16"
security_group_protocol      = "tcp"
security_group_app_port      = [80, 8080]
security_group_ssh_port      = 22
security_group_database_port = 5432

# EKS VARS
eks_cluster_name    = "hitc-eks-cluster"
eks_node_group_name = "hitc-ng"
