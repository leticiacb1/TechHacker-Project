# Default  trial to internet gateway
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da VPC

  route {
    cidr_block = "0.0.0.0/0"

    # Identificar a nossa VPC internet gateway
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}