
module "vpc" {
  source = "./modules/aws/vpc"

  cidr_block             = var.vpc_cidr_block
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support
  instance_tenancy       = var.instance_tenancy
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = {
    Name                             = "${var.environment}-vpc"
  }
}

module "public-subnet-one" {
  source = "./modules/aws/subnet"

  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_one_cidr
  availability_zone       = local.availability_zone_names[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Environment                                 = var.environment
    Name                                        = "${var.environment}-public-subnet-one"   
    "kubernetes.io/cluster/${var.environment}-${var.eks_cluster_name}-cluster" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

module "public-subnet-two" {
  source = "./modules/aws/subnet"

  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_two_cidr
  availability_zone       = local.availability_zone_names[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Environment                                 = var.environment
    Name                                        = "${var.environment}-public-subnet-two"   
    "kubernetes.io/cluster/${var.environment}-${var.eks_cluster_name}-cluster" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

module "public-subnet-three" {
  source = "./modules/aws/subnet"

  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_three_cidr
  availability_zone       = local.availability_zone_names[2]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Environment                                 = var.environment
    Name                                        = "${var.environment}-public-subnet-three"   
    "kubernetes.io/cluster/${var.environment}-${var.eks_cluster_name}-cluster" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

module "internet-gateway" {
  source = "./modules/aws/internet-gateway"

  vpc_id               = module.vpc.vpc_id

  tags = {
    Environment = var.environment
    Name = "${var.environment}-igw"
  }
}

module "public-route-table" {
  source = "./modules/aws/route-table"

  vpc_id = module.vpc.vpc_id
  cidr_block = var.public_route_table_cidr_block
  gateway_id = module.internet-gateway.internet_gateway_id

  tags = {
    Environment = var.environment
    Name = "${var.environment}-route-table-public"
  }
}

module "public-subnet-one-route-table-association" {
  source = "./modules/aws/route-table-association"

  subnet_id      = module.public-subnet-one.subnet_id
  route_table_id = module.public-route-table.route_table_id

}

module "public-subnet-two-route-table-association" {
  source = "./modules/aws/route-table-association"

  subnet_id      = module.public-subnet-two.subnet_id
  route_table_id = module.public-route-table.route_table_id

}

module "public-subnet-three-route-table-association" {
  source = "./modules/aws/route-table-association"

  subnet_id      = module.public-subnet-three.subnet_id
  route_table_id = module.public-route-table.route_table_id

}
