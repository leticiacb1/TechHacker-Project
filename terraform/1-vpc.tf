# VPC
resource "aws_vpc" "main-vpc" {

  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  # Requires for EKS
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Output VPC
# Útil para quando trabalhamos com módulos
output "vpc_id" {
  value       = aws_vpc.main-vpc.id
  description = "VPC id"
}