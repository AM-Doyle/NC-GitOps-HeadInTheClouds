module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  cluster_endpoint_public_access = true
  cluster_additional_security_group_ids = var.security_group_ids

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  # For cost management purposes
  # a single node group, with a 
  # single node within the group
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 3
      max_size     = 3
      desired_size = 3
    }
  }
}