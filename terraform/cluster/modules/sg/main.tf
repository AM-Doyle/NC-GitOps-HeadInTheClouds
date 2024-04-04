#IP data
data "http" "ssh_cidr" {
  url = "https://ipv4.icanhazip.com"
}

#EKS Cluster SG
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security groups for EKS cluster"
  vpc_id      = var.vpc_id

  #Ingress rule for SSH access
  ingress {
    from_port         = var.ssh_port
    to_port           = var.ssh_port
    protocol          = var.protocol
    cidr_blocks       = ["${chomp(data.http.ssh_cidr.response_body)}/32", var.cird_16]
  }

  #Ingress rules for HTTP (app_port[0])
  ingress {
    from_port         = var.app_port[0]
    to_port           = var.app_port[0]
    protocol          = var.protocol
    cidr_blocks       = [var.cidr_0]
  }

  #Ingress rules for HTTP (app_port[0])
    ingress {
    from_port         = var.app_port[1]
    to_port           = var.app_port[1]
    protocol          = var.protocol
    cidr_blocks       = [var.cidr_0]
  }

  #Ingress rules for database
  ingress {
    from_port = var.database_port
    to_port = var.database_port
    protocol = var.protocol
    cidr_blocks = [var.cidr_0]
  }
}