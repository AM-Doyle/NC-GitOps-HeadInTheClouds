# IAM Role
module "iam" {
  source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  trusted_role_services   = ["ec2.amazonaws.com"]
  role_name               = var.iam_role_jenkins_name
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true
  custom_role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# VPC Module
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.vpc_name
  cidr                 = var.security_group_cidr_block_16
  azs                  = var.vpc_availability_zones
  public_subnets       = var.vpc_public_subnet_ids
  private_subnets      = var.vpc_private_subnet_ids
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# EC2 Module
module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = var.ec2_name
  instance_type               = var.ec2_instance_type
  ami                         = var.ec2_ami_type
  associate_public_ip_address = true
  key_name                    = var.ec2_key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.security.security_group_id]
  iam_instance_profile        = module.iam.iam_role_name
  user_data                   = <<-EOF
      #!/bin/bash
      sudo apt-get update -y
      sudo apt-get install -y openjdk-11-jre
      curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt-get update -y
      sudo apt-get install -y jenkins
      sudo systemctl start jenkins
      sudo systemctl enable jenkins
      sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get update -y
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io
      sudo usermod -aG docker ubuntu
      sudo systemctl start docker
      sudo systemctl enable docker
      sudo usermod -aG docker jenkins
      sudo systemctl restart jenkins
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      sudo apt install -y unzip
      unzip awscliv2.zip
      sudo ./aws/install
      curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
      sudo apt-get install apt-transport-https --yes
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt-get update -y
      sudo apt-get install -y helm
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  EOF
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# RDS Module
module "rds" {
  source                 = "terraform-aws-modules/rds/aws"
  depends_on             = [module.vpc]
  db_name                = var.rds_db_name
  identifier             = var.rds_db_identifier
  engine                 = var.rds_db_engine
  engine_version         = var.rds_db_engine_version
  instance_class         = var.rds_db_instance_class
  skip_final_snapshot    = true
  publicly_accessible    = true
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.security.security_group_id]
  family                 = var.rds_db_family
  allocated_storage      = var.rds_db_allocated_storage
  username               = local.db_creds.POSTGRES_USERNAME
  password               = local.db_creds.POSTGRES_PASSWORD
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
data "aws_secretsmanager_secret_version" "rds-db-creds" {
  secret_id = var.rds_db_creds
}
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.rds-db-creds.secret_string)
}

# Security Group Module
data "http" "sg_cidr" {
  url = "https://ipv4.icanhazip.com"
}
module "security" {
  source      = "terraform-aws-modules/security-group/aws"
  depends_on  = [module.vpc]
  name        = var.security_group_name
  description = "Security Groups For EKS Cluster."
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.security_group_ssh_port
      to_port     = var.security_group_ssh_port
      protocol    = var.security_group_protocol
      description = "SSH"
      cidr_blocks = var.security_group_cidr_block_16
    },
    {
      from_port   = var.security_group_ssh_port
      to_port     = var.security_group_ssh_port
      protocol    = var.security_group_protocol
      description = "SSH"
      cidr_blocks = "${chomp(data.http.sg_cidr.response_body)}/32"
    },
    {
      from_port   = var.security_group_app_port[0]
      to_port     = var.security_group_app_port[0]
      protocol    = var.security_group_protocol
      description = "HTTP/S - Frontend"
      cidr_blocks = var.security_group_cidr_block_16
    },
    {
      from_port   = var.security_group_app_port[1]
      to_port     = var.security_group_app_port[1]
      protocol    = var.security_group_protocol
      description = "HTTP/S - Backend"
      cidr_blocks = "${chomp(data.http.sg_cidr.response_body)}/32"
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Jenkins"
      cidr_blocks = var.security_group_cidr_block_16
    },
    {
      from_port   = var.security_group_database_port
      to_port     = var.security_group_database_port
      protocol    = var.security_group_protocol
      description = "Database"
      cidr_blocks = var.security_group_cidr_block_16
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All Traffic"
      cidr_blocks = var.security_group_cidr_block_0
    }
  ]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# EKS Module
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  depends_on = [module.vpc,
  module.iam]
  version                                  = "~> 20.0"
  cluster_name                             = var.eks_cluster_name
  cluster_version                          = "1.29"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  cluster_additional_security_group_ids    = [module.security.security_group_id]
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  create_iam_role                          = true
  iam_role_use_name_prefix                 = false
  iam_role_name                            = var.iam_role_node_group_name
  iam_role_description                     = "HITC IAM Role For Node Group."
  access_entries = {
    ex-multiple = {
      kubernetes_groups = []
      principal_arn     = module.iam.iam_role_arn
      policy_associations = {
        ex-one = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        ex-two = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small"]
  }
  eks_managed_node_groups = {
    one = {
      name           = var.eks_node_group_name
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 5
      desired_size   = 3
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
