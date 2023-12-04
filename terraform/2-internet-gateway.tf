resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-gateway"
  }
}