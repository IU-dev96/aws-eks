# EKS Cluster Resource
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  # Enable CloudWatch logging for control plane components
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.eks_control_plane_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true # Set to false if you only want private access
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# EKS Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids

  # Instance Type Selection:
  # To meet 256 vCPU & 200GB vRAM, we use 8 x m6i.8xlarge instances.
  # Each m6i.8xlarge has 32 vCPU and 128 GiB RAM.
  # Total vCPU: 8 * 32 = 256 vCPU
  # Total RAM: 8 * 128 GiB = 1024 GiB (exceeds 200GB requirement)
  instance_types = ["m6i.8xlarge"]

  # Node (ephemeral) Storage:
  disk_size = 200 # in GB

  scaling_config {
    desired_size = 8
    max_size     = 10
    min_size     = 8 # Fixed size to guarantee resources
  }

  vpc_security_group_ids = [var.eks_nodes_sg_id]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
  ]
}

# Add-on for AWS EBS CSI Driver to manage persistent volumes
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-ebs-csi-driver"
}