variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "eks_control_plane_sg_id" {
  type = string
}

variable "eks_nodes_sg_id" {
  type = string
}