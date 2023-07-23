#### General Variables ####

variable "environment" {
    default = "test"
}

variable "aws_region" {
    default = "us-east-1"
}

// Task Defining Variables

variable "task_one" {
    default = false
}
variable "task_two" {
    default = false
}

// VPC

variable "vpc_cidr_block" {
    default = "10.3.0.0/16"
}

variable "enable_dns_hostnames" {
    default = true
}

variable "enable_dns_support" {
    default = true
}

variable "instance_tenancy" {
    default = "default"
}

variable "enable_network_address_usage_metrics" {
    default = false
}

variable "map_public_ip_on_launch" {
    default = true
}

// Subnets

variable "public_subnet_one_cidr" {
    default = "10.3.1.0/24"
}

variable "public_subnet_two_cidr" {
    default = "10.3.2.0/24"
}

variable "public_subnet_three_cidr" {
    default = "10.3.3.0/24"
}

variable "public_route_table_cidr_block" {
    default = "0.0.0.0/0"
}

// EKS

variable "eks_cluster_name" {
    default = "tradition"
}

variable "eks_cluster_version" {
    default = "1.27"
}