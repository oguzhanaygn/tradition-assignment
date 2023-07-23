resource "aws_security_group_rule" "sg-rule-cidr" {
  count = var.defined_for_cidr_block ? 1 : 0
  
  type              = var.type
  protocol          = var.protocol
  from_port         = var.from_port
  to_port           = var.to_port
  cidr_blocks       = var.cidr_blocks
  security_group_id = var.security_group_id
  description       = var.description
}

resource "aws_security_group_rule" "sg-rule-source" {
  count = var.defined_for_source_sg ? 1 : 0

  type              = var.type
  protocol          = var.protocol
  from_port         = var.from_port
  to_port           = var.to_port
  source_security_group_id  = var.source_security_group_id
  security_group_id = var.security_group_id
  description       = var.description
}
