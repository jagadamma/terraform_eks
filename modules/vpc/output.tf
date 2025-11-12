############################################################
# ✅ FINAL OUTPUTS FOR VPC MODULE (Production-ready)
############################################################

# The VPC ID — used by EKS, ALB, or other resources
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

# Public Subnets — for ALB, NAT Gateways, etc.
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# Private Subnets — for EKS, RDS, etc.
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# Route Tables (useful for networking references)
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_rt.id
}

# Internet Gateway ID
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# NAT Gateway ID
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

# Availability Zones used
output "availability_zones" {
  description = "List of availability zones used by this VPC"
  value       = var.availability_zones
}
