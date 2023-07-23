resource "aws_iam_role" "iam-role" {
  name = var.name

  assume_role_policy = var.assume_role_policy

  description = var.description

  tags = var.tags
}
