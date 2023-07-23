resource "aws_eks_cluster" "eks-cluster" {
  name                      = var.name
  role_arn                  = var.role_arn
  version                   = var.eks_cluster_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
    ip_family = var.ip_family
  }

  tags = var.tags

}
