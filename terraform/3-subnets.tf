resource "aws_subnet" "subnet-public-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.0.0/18"

  # AZ subnet
  availability_zone = var.aval_zone

  # Qualquer intancia lançada nessa rede pública, recebe um IP de forma automática
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-${var.aval_zone}"     
  }

}
