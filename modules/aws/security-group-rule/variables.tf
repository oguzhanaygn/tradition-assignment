variable "type" {}
variable "protocol" {}
variable "from_port" {}
variable "to_port" {}
variable "security_group_id" {}
variable "description" {}

variable "defined_for_source_sg" {
    default = false
}
variable "defined_for_cidr_block" {
    default = false
}
variable "source_security_group_id" {
    default = null
}
variable "cidr_blocks" {
    default = null
}