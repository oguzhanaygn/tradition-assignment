output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "eks_cluster_controlplane_sg_id" {
  value = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
  sensitive = true
}
output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
  sensitive = true
}