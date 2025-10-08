# Customer Gateway (represents your on-prem router)
resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000 # Standard private ASN
  ip_address = var.on_prem_gateway_ip
  type       = "ipsec.1"

  tags = {
    Name = "${var.on_prem_gateway_ip}-cgw"
  }
}

# Virtual Private Gateway (the VPN endpoint on the AWS side)
resource "aws_vpn_gateway" "main" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.vpc_id}-vgw"
  }
}

# The Site-to-Site VPN Connection
resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = "ipsec.1"
  static_routes_only  = true
}

# Route for on-prem traffic
resource "aws_vpn_connection_route" "on_prem" {
  destination_cidr_block = var.on_prem_cidr_block
  vpn_connection_id      = aws_vpn_connection.main.id
}

# Add route to private subnets to direct on-prem traffic to the VGW
resource "aws_route" "to_on_prem" {
  count                  = length(var.private_route_table_ids)
  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = var.on_prem_cidr_block
  gateway_id             = aws_vpn_gateway.main.id
}