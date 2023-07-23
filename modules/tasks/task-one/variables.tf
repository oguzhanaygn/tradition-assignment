variable "environment" {}

variable "vpc_id" {}

variable "security_group_ingress_cidr_blocks" {}

variable "autoscaling_group_vpc_zone_identifier" {}

variable "task_number" {}

// SSH Key

variable "ssh_key_algorithm" {
  default = "RSA"
}

variable "ssh_key_rsa_bits" {
  default = "4096"
}

// Launch Template

variable "launch_template_image_id" {}

variable "launch_template_instance_type" {
  default = "t3.micro"
}

variable "launch_template_update_default_version" {
  default = true
}

variable "launch_template_block_device_name" {
  default = "/dev/xvda"
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

// AutoScaling Group

variable "autoscaling_group_availability_zones" {}
variable "autoscaling_group_desired_capacity" {
  default = 2
}
variable "autoscaling_group_max_size" {
  default = 2
}
variable "autoscaling_group_min_size" {
  default = 2
}
variable "autoscaling_group_launch_template_version" {
    default = "$Latest"
}

// Security Group

variable "security_group_ingress_rule" {
  type = map
  default = {
    "type"     = "ingress"
    "protocol" = "tcp"
    "http_port" = 80
    "https_port" = 443
    "ssh_port" = 22
  }
}

variable "security_group_egress_rule" {
  type = map
  default = {
    "type"     = "egress"
    "protocol" = "-1"
    "from_port" = 0
    "to_port"   = 0
    "egress_cidr_block" = "0.0.0.0/0"
  }
}