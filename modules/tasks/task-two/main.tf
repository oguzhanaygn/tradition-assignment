// SSH Key Pair

module "task-two-ssh-private-key" {
  source = "../../aws/tls-private-key"

  algorithm = var.ssh_key_algorithm
  rsa_bits  = var.ssh_key_rsa_bits
}

module "task-two-ssh-key" {
  source = "../../aws/key-pair"

  key_name = "${var.environment}-${var.task_number}-eks-ssh-key"
  public_key = module.task-two-ssh-private-key.public_key
  private_key = module.task-two-ssh-private-key.private_key
  environment = var.environment
  task_number = var.task_number
}

// EKS Cluster

module "eks-cluster" {
  source = "../../aws/eks-cluster"
  
  name                      = var.eks_cluster_name
  role_arn                  = module.eks-cluster-iam-role.iam_role_arn
  eks_cluster_version       = var.eks_cluster_version
  enabled_cluster_log_types = var.eks_cluster_enabled_log_types
  subnet_ids              = var.eks_cluster_subnet_ids
  endpoint_private_access = var.eks_cluster_endpoint_private_access
  public_access_cidrs     = var.eks_cluster_public_access_ips
  service_ipv4_cidr = var.eks_cluster_service_ipv4_cidr
  ip_family   = var.eks_cluster_ip_family

  tags = {
      Environment  = var.environment
      Name = var.eks_cluster_name
      Version = var.eks_cluster_version
    }
  depends_on = [module.eks-cluster-cloudwatch-log-group]

}

module "eks-cluster-cloudwatch-log-group" {
  source = "../../aws/cloudwatch-log-group"
  
  name    = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.eks_cluster_logs_retention_in_days
}

// Launch Template

module "eks-nodegroup-launch-template" {
  source = "../../aws/launch-template"

  name                   = "${var.eks_cluster_name}-${var.eks_nodegroup_name}-launch-template"
  image_id               = var.launch_template_image_id
  update_default_version = var.launch_template_update_default_version
  instance_type = var.launch_template_instance_type
  key_name = module.task-two-ssh-key.key_pair_name
  block_device_name = var.launch_template_block_device_name
  volume_size = var.launch_template_disk_size
  ebs_optimized = var.launch_template_ebs_optimized
  monitoring_enabled = var.launch_template_monitoring_enabled
  resources_to_tag = var.launch_template_resource_type
  vpc_security_group_ids = [module.eks-cluster.eks_cluster_controlplane_sg_id, module.task-two-nodegroup-security-group.security_group_id]

  user_data = base64encode(templatefile("${path.module}/userdata.toml.tpl", { CLUSTER_NAME = var.eks_cluster_name, B64_CLUSTER_CA = module.eks-cluster.eks_cluster_certificate_authority, API_SERVER_URL = module.eks-cluster.eks_cluster_endpoint } ))
 
  tags = {
      Environment  = var.environment
      Name  = "${var.eks_cluster_name}-${var.eks_nodegroup_name}-nodes"
    }
  
}

// Node Group

module "eks-nodegroup" {
  source = "../../aws/eks-nodegroup"

  cluster_name    = module.eks-cluster.eks_cluster_name
  node_group_name = var.eks_nodegroup_name
  node_role_arn  = module.eks-nodegroup-iam-role.iam_role_arn
  subnet_ids     = var.eks_nodegroup_subnet_ids
  desired_size = var.eks_nodegroup_desired_size
  max_size     = var.eks_nodegroup_max_size
  min_size     = var.eks_nodegroup_min_size
  launch_template_id        = module.eks-nodegroup-launch-template.launch_template_id
  launch_template_version   = var.eks_nodegroup_launch_template_version

  labels = {
    "env" = var.environment
    "nodegroup_name" = var.eks_nodegroup_name
  }

  tags = {
    Environment = var.environment
    cluster_name = var.eks_cluster_name
  }

  depends_on = [module.eks-nodegroup-launch-template, module.eks-cluster]
}

// IAM Roles

module "eks-cluster-iam-role" {
  source = "../../aws/iam-role"

  name               = "${var.eks_cluster_name}-cluster-iam-role"
  assume_role_policy = jsonencode(var.eks_cluster_iam_role_assume_role_policy)
  description        = "IAM Role for EKS Cluster ${var.eks_cluster_name}"

  tags = {
    Environment = var.environment
  }
}

module "eks-nodegroup-iam-role" {
  source = "../../aws/iam-role"

  name               = "${var.environment}-${var.eks_nodegroup_name}-nodegroup-iam-role"
  assume_role_policy = jsonencode(var.eks_nodegroup_iam_role_assume_role_policy)
  description        = "IAM Role for EKS Cluster ${var.environment} ${var.eks_nodegroup_name} NodeGroup"

  tags = {
    Environment = var.environment
  }
}

// IAM Policies

module "eks-nodegroup-autoscaler-iam-policy" {
  source = "../../aws/iam-policy"

  name        = "${var.environment}-${var.eks_nodegroup_name}-nodegroup-autoscaler-iam-policy"
  path        = var.eks_nodegroup_autoscaler_iam_policy_path
  description = "AutoScaler IAM Policy for EKS Cluster ${var.environment} ${var.eks_nodegroup_name} NodeGroup"
  policy      = jsonencode(var.eks_nodegroup_autoscaler_iam_policy)

  tags = {
    Environment = var.environment
  }
}

// Policy Attachments

module "eks-cluster-iam-role-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  policy_arn = var.eks_cluster_iam_policy_arn
  role       = module.eks-cluster-iam-role.iam_role_name
}

module "eks-cluster-service-iam-role-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  policy_arn = var.eks_cluster_service_iam_policy_arn
  role       = module.eks-cluster-iam-role.iam_role_name
}

module "eks-nodegroup-iam-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  role       = module.eks-nodegroup-iam-role.iam_role_name
  policy_arn = var.eks_nodegroup_iam_policy
}

module "eks-nodegroup-cni-iam-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  role       = module.eks-nodegroup-iam-role.iam_role_name
  policy_arn = var.eks_nodegroup_cni_iam_policy
}

module "eks-nodegroup-ecr-readonly-iam-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  role       = module.eks-nodegroup-iam-role.iam_role_name
  policy_arn = var.eks_nodegroup_ecr_read_only_policy
}

module "eks-nodegroup-ssm-iam-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  role       = module.eks-nodegroup-iam-role.iam_role_name
  policy_arn = var.eks_nodegroup_ssm_policy
}

module "eks-nodegroup-autoscaler-iam-policy-attachment" {
  source = "../../aws/iam-role-policy-attachment"

  role       = module.eks-nodegroup-iam-role.iam_role_name
  policy_arn = module.eks-nodegroup-autoscaler-iam-policy.iam_policy_arn
}
 // Node Group Additional Security Group

module "task-two-nodegroup-security-group" {
  source = "../../aws/security-group"

  name        = "${var.environment}-${var.task_number}-nodegroup-security-group"
  description = "EKS Node Group Security Group for port 22"
  vpc_id      = var.vpc_id

  tags = {
      Environment  = var.environment
      Name  = "${var.environment}-${var.task_number}-security-group"
    }
} 

module "task-two-nodegroup-security-group-ssh-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.nodegroup_security_group_ingress_rule.type
  protocol          = var.nodegroup_security_group_ingress_rule.protocol
  from_port         = var.nodegroup_security_group_ingress_rule.ssh_port
  to_port           = var.nodegroup_security_group_ingress_rule.ssh_port
  cidr_blocks       = var.eks_cluster_public_access_ips
  security_group_id = module.task-two-nodegroup-security-group.security_group_id
  description       = "ssh"

}

module "task-two-nodegroup-security-group-egress-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.nodegroup_security_group_egress_rule.type
  protocol          = var.nodegroup_security_group_egress_rule.protocol
  from_port         = var.nodegroup_security_group_egress_rule.from_port
  to_port           = var.nodegroup_security_group_egress_rule.to_port
  cidr_blocks       = [var.nodegroup_security_group_egress_rule.egress_cidr_block]
  security_group_id = module.task-two-nodegroup-security-group.security_group_id
  description       = "egress"

}

// Load Balancer Security Group

module "task-two-loadbalancer-security-group" {
  source = "../../aws/security-group"

  name        = "${var.environment}-${var.task_number}-loadbalancer-security-group"
  description = "EKS Load Balancer Security Group"
  vpc_id      = var.vpc_id

  tags = {
      Environment  = var.environment
      Name  = "${var.environment}-${var.task_number}-loadbalancer-security-group"
    }
} 

module "task-two-loadbalancer-security-group-http-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.loadbalancer_security_group_ingress_rule.type
  protocol          = var.loadbalancer_security_group_ingress_rule.protocol
  from_port         = var.loadbalancer_security_group_ingress_rule.http_port
  to_port           = var.loadbalancer_security_group_ingress_rule.http_port
  cidr_blocks       = var.eks_cluster_public_access_ips
  security_group_id = module.task-two-loadbalancer-security-group.security_group_id
  description       = "http"

}

module "task-two-loadbalancer-security-group-egress-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.loadbalancer_security_group_egress_rule.type
  protocol          = var.loadbalancer_security_group_egress_rule.protocol
  from_port         = var.loadbalancer_security_group_egress_rule.from_port
  to_port           = var.loadbalancer_security_group_egress_rule.to_port
  cidr_blocks       = [var.loadbalancer_security_group_egress_rule.egress_cidr_block]
  security_group_id = module.task-two-loadbalancer-security-group.security_group_id
  description       = "http"

}

resource "local_file" "service-yaml-sg-template" {
  content  = templatefile("${path.module}/k8s-deployment-files/service.yaml.tpl", {
        loadBalancer_sg_id = "${module.task-two-loadbalancer-security-group.security_group_id}"
    })
  filename = "${path.module}/k8s-deployment-files/service.yaml"
}