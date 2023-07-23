variable "environment" {}
variable "task_number" {}
variable "vpc_id" {}
// SSH Key

variable "ssh_key_algorithm" {
  default = "RSA"
}

variable "ssh_key_rsa_bits" {
  default = "4096"
}

variable "eks_cluster_iam_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

variable "eks_cluster_service_iam_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

variable "eks_cluster_iam_role_assume_role_policy" {
  default = {
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  }
}

variable "eks_nodegroup_iam_role_assume_role_policy" {
  default = {
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  }
}

variable "eks_nodegroup_iam_policy" {
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "eks_nodegroup_cni_iam_policy" {
  default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

variable "eks_nodegroup_ecr_read_only_policy" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

variable "eks_nodegroup_ssm_policy" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "eks_nodegroup_autoscaler_iam_policy_path" {
  default = "/"
}

variable "eks_nodegroup_autoscaler_iam_policy" {
  default = {
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ]
      "Effect" = "Allow",
      "Resource" = "*"
    }]
    Version = "2012-10-17"
}
}

// EKS CLUSTER //

variable "eks_cluster_subnet_ids" {}

variable "eks_cluster_public_access_ips" {}

variable "eks_cluster_name" {}

variable "eks_cluster_version" {}

variable "eks_cluster_enabled_log_types" {
  default = ["api", "audit", "scheduler", "controllerManager", "authenticator"]
}

variable "eks_cluster_endpoint_private_access" {
  default = true
}

variable "eks_cluster_service_ipv4_cidr" {
  default = "172.20.0.0/16"
}

variable "eks_cluster_ip_family" {
  default = "ipv4"
}

// EKS NODE GROUPS //

variable "eks_nodegroup_subnet_ids" {}

variable "eks_nodegroup_max_size" {
  default = 2
}

variable "eks_nodegroup_desired_size" {
  default = 2
}

variable "eks_nodegroup_min_size" {
  default = 2
}

variable "eks_nodegroup_launch_template_version" {
  default = "$Latest"
}

variable "eks_nodegroup_name" {
  default = "test"
}

// Launch Template

variable "launch_template_image_id" {}

variable "launch_template_instance_type" {
  default = "t3.small"
}

variable "launch_template_update_default_version" {
  default = true
}

variable "launch_template_block_device_name" {
  default = "/dev/xvdb"
}

variable "launch_template_disk_size" {
  default = 10
}

variable "launch_template_ebs_optimized" {
  default = true
}

variable "launch_template_monitoring_enabled" {
  default = true
}

variable "launch_template_resource_type" {
  default = ["instance", "volume"]
}

// Log Group

variable "eks_cluster_logs_retention_in_days" {
  default = 7
}

// NodeGroup Security Group

variable "nodegroup_security_group_ingress_rule" {
  type = map
  default = {
    "type"     = "ingress"
    "protocol" = "tcp"
    "ssh_port" = 22
  }
}

variable "nodegroup_security_group_egress_rule" {
  type = map
  default = {
    "type"     = "egress"
    "protocol" = "-1"
    "from_port" = 0
    "to_port"   = 0
    "egress_cidr_block" = "0.0.0.0/0"
  }
}

// NodeGroup Security Group

variable "loadbalancer_security_group_ingress_rule" {
  type = map
  default = {
    "type"     = "ingress"
    "protocol" = "tcp"
    "http_port" = 80
  }
}

variable "loadbalancer_security_group_egress_rule" {
  type = map
  default = {
    "type"     = "egress"
    "protocol" = "-1"
    "from_port" = 0
    "to_port"   = 0
    "egress_cidr_block" = "0.0.0.0/0"
  }
}