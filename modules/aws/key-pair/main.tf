resource "aws_key_pair" "key-pair" {
  key_name   = var.key_name
  public_key = var.public_key

  provisioner "local-exec" {   
    command = <<-EOT
      echo '${var.private_key}' > ${var.environment}-${var.task_number}-key-pair.pem
      chmod 400 ${var.environment}-${var.task_number}-key-pair.pem
    EOT
}
}
