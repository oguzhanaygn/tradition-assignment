resource "local_file" "service-yaml-sg-template" {
  content  = var.content
  filename = var.filename
}