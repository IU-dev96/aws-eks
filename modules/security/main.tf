# Security group for the EKS control plane
resource "aws_security_group" "eks_control_plane" {
  name        = "${var.project_name}-eks-control-plane-sg"
  description = "EKS control plane security group"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from nodes
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eks-control-plane-sg"
  }
}

# Security group for the EKS worker nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-eks-nodes-sg"
  description = "EKS worker nodes security group"
  vpc_id      = var.vpc_id

  # Allow all traffic from the control plane
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks_control_plane.id]
  }

  # Allow all traffic between nodes in the same SG
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  # Allow outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eks-nodes-sg"
  }
}

# AWS GuardDuty provides intelligent threat detection for your AWS account.
# Enabling it is a critical security best practice.
resource "aws_guardduty_detector" "default" {
  enable = true
}
