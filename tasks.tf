module "task-one-resources" {
    count = var.task_one ? 1 : 0
    source = "./modules/tasks/task-one"

    vpc_id = module.vpc.vpc_id
    task_number = "task-one"
    environment = var.environment
    launch_template_image_id = data.aws_ami.amazon-linux-2.id
    security_group_ingress_cidr_blocks = ["${chomp(data.http.client-ip.body)}/32"]
    autoscaling_group_availability_zones = [local.availability_zone_names[0], local.availability_zone_names[1], local.availability_zone_names[2]]
    autoscaling_group_vpc_zone_identifier = data.aws_subnets.all.ids

}

module "task-two-resources" {
    count = var.task_two ? 1 : 0
    source = "./modules/tasks/task-two"

    vpc_id = module.vpc.vpc_id
    environment = var.environment
    task_number = "task-two"
    launch_template_image_id = data.aws_ami.bottlerocket-ami.id
    eks_cluster_public_access_ips = ["${chomp(data.http.client-ip.body)}/32"]
    eks_nodegroup_subnet_ids = data.aws_subnets.all.ids
    eks_cluster_subnet_ids = data.aws_subnets.all.ids
    eks_cluster_name = "${var.environment}-${var.eks_cluster_name}-cluster"
    eks_cluster_version = var.eks_cluster_version

}
