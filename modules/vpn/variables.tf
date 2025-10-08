variable "vpc_id" {
  type = string
}

variable "on_prem_gateway_ip" {
  type      = string
  sensitive = true
}

variable "on_prem_cidr_block" {
  type = string
}

variable "private_route_table_ids" {
  type = list(string)
}