output "eks_cluster_endpoint" {
  description = "Endpoint for your EKS Kubernetes API server."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "s3_bucket_name" {
  description = "The name of the provisioned S3 bucket."
  value       = module.storage.bucket_name
}

output "vpn_connection_id" {
  description = "The ID of the Site-to-Site VPN connection."
  value       = module.s2s_vpn.vpn_connection_id
}