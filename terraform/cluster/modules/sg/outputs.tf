output "security_group_ids" {
  value = [
    aws_security_group.eks_cluster_sg.id,
    ]
}