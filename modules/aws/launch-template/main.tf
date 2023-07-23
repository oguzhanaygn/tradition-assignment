resource "aws_launch_template" "launch-template" {
  name                   = var.name
  update_default_version = var.update_default_version
  instance_type = var.instance_type
  image_id = var.image_id
  key_name = var.key_name
  block_device_mappings {
    device_name = var.block_device_name
    ebs {
      volume_size = var.volume_size
    }
  }
  ebs_optimized = var.ebs_optimized

  monitoring {
    enabled = var.monitoring_enabled
  }

  dynamic "tag_specifications" {
    for_each = toset(var.resources_to_tag)
    content {
       resource_type = tag_specifications.key
       tags = var.tags
    }
  }

  vpc_security_group_ids = var.vpc_security_group_ids

  user_data = var.user_data
  
}