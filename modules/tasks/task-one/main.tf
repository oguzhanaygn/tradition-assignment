module "task-one-ssh-private-key" {
  source = "../../aws/tls-private-key"

  algorithm = var.ssh_key_algorithm
  rsa_bits  = var.ssh_key_rsa_bits
}

module "task-one-ssh-key" {
  source = "../../aws/key-pair"

  key_name = "${var.environment}-${var.task_number}-ssh-key"
  public_key = module.task-one-ssh-private-key.public_key
  private_key = module.task-one-ssh-private-key.private_key
  environment = var.environment
  task_number = var.task_number
}


module "task-one-autoscaling-group" {
  source = "../../aws/autoscaling-group"

  name               = "${var.environment}-${var.task_number}-autoscaling-group"
  desired_capacity   = var.autoscaling_group_desired_capacity
  max_size           = var.autoscaling_group_max_size
  min_size           = var.autoscaling_group_min_size
  vpc_zone_identifier = var.autoscaling_group_vpc_zone_identifier

  launch_template_id = module.task-one-launch-template.launch_template_id
  launch_template_version = var.autoscaling_group_launch_template_version

  depends_on = [
    module.task-one-launch-template
  ]
}

module "task-one-launch-template" {
  source = "../../aws/launch-template"

  name                   = "${var.environment}-${var.task_number}-launch-template"
  image_id               = var.launch_template_image_id
  update_default_version = var.launch_template_update_default_version
  instance_type = var.launch_template_instance_type
  key_name = module.task-one-ssh-key.key_pair_name
  block_device_name = var.launch_template_block_device_name
  volume_size = var.launch_template_disk_size
  ebs_optimized = var.launch_template_ebs_optimized
  monitoring_enabled = var.launch_template_monitoring_enabled
  resources_to_tag = var.launch_template_resource_type
  vpc_security_group_ids = [module.task-one-security-group.security_group_id]

  user_data = base64encode(file("${path.module}/userdata.sh"))
 
  tags = {
      Environment  = var.environment
      Name  = "${var.environment}-${var.task_number}-launch-template"
    }
}

module "task-one-security-group" {
  source = "../../aws/security-group"

  name        = "${var.environment}-${var.task_number}-security-group"
  description = "Apache Security Group for port 22, 80 and 443"
  vpc_id      = var.vpc_id

  tags = {
      Environment  = var.environment
      Name  = "${var.environment}-${var.task_number}-security-group"
    }
}

// Security Group and Rules

module "task-one-security-group-http-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.security_group_ingress_rule.type
  protocol          = var.security_group_ingress_rule.protocol
  from_port         = var.security_group_ingress_rule.http_port
  to_port           = var.security_group_ingress_rule.http_port
  cidr_blocks       = var.security_group_ingress_cidr_blocks
  security_group_id = module.task-one-security-group.security_group_id
  description       = "http"

}

module "task-one-security-group-https-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.security_group_ingress_rule.type
  protocol          = var.security_group_ingress_rule.protocol
  from_port         = var.security_group_ingress_rule.https_port
  to_port           = var.security_group_ingress_rule.https_port
  cidr_blocks       = var.security_group_ingress_cidr_blocks
  security_group_id = module.task-one-security-group.security_group_id
  description       = "https"

}

module "task-one-security-group-ssh-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.security_group_ingress_rule.type
  protocol          = var.security_group_ingress_rule.protocol
  from_port         = var.security_group_ingress_rule.ssh_port
  to_port           = var.security_group_ingress_rule.ssh_port
  cidr_blocks       = var.security_group_ingress_cidr_blocks
  security_group_id = module.task-one-security-group.security_group_id
  description       = "ssh"

}

module "task-one-security-group-egress-rule" {
  source = "../../aws/security-group-rule"

  defined_for_cidr_block = true

  type              = var.security_group_egress_rule.type
  protocol          = var.security_group_egress_rule.protocol
  from_port         = var.security_group_egress_rule.from_port
  to_port           = var.security_group_egress_rule.to_port
  cidr_blocks       = [var.security_group_egress_rule.egress_cidr_block]
  security_group_id = module.task-one-security-group.security_group_id
  description       = "egress"

}