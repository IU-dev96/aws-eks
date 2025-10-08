# Creates the foundational network: VPC, subnets, gateways, and routes.
module "vpc" {
  source = "../modules/vpc"

  project_name = var.project_name
  aws_region   = var.aws_region
  vpc_cidr     = "10.0.0.0/16"
  public_subnets_cidr = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  private_subnets_cidr = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}

# --- Security Module ---
# Defines security groups for EKS control plane and worker nodes.
module "security" {
  source = "../modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# --- Site-to-Site VPN Module ---
# Establishes a VPN connection to your on-premises network.
module "s2s_vpn" {
  source = "../modules/s2s_vpn"

  vpc_id                 = module.vpc.vpc_id
  on_prem_gateway_ip     = var.on_prem_gateway_ip
  on_prem_cidr_block     = var.on_prem_cidr_block
  private_route_table_ids = module.vpc.private_route_table_ids
}

# --- EKS Cluster Module ---
# Provisions the EKS control plane, node groups, and necessary IAM roles.
module "eks" {
  source = "../modules/eks"

  project_name      = var.project_name
  cluster_name      = "${var.project_name}-eks-cluster"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.vpc_id

  eks_control_plane_sg_id = module.security.eks_control_plane_sg_id
  eks_nodes_sg_id         = module.security.eks_nodes_sg_id
}

# --- Storage Module ---
# Creates the S3 bucket for object storage.
module "storage" {
  source = "../modules/storage"

  bucket_name  = "${var.project_name}-data-bucket-logs-and-backups"
  project_name = var.project_name
}
