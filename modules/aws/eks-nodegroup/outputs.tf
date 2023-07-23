output "eks_nodegroup_sg" {
  value = aws_eks_node_group.eks-nodegroup.resources.0.remote_access_security_group_id
}

output "eks_nodegroup_asg_name" {
  value = aws_eks_node_group.eks-nodegroup.resources.0.autoscaling_groups.0.name
}
