resource "aws_eks_node_group" "eks-nodegroup" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.subnet_ids

  labels = var.labels

  tags = var.tags

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    id        = var.launch_template_id
    version   = var.launch_template_version
  }

  lifecycle {
     ignore_changes = [scaling_config.0.desired_size, launch_template[0].version]
  }
}
