variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "A name for the project to prefix resources."
  type        = string
  default     = "my-app"
}

variable "on_prem_gateway_ip" {
  description = "The public IP address of your on-premises VPN gateway."
  type        = string
  sensitive   = true
}

variable "on_prem_cidr_block" {
  description = "The CIDR block of your on-premises network."
  type        = string
  default     = "192.168.0.0/16"
}