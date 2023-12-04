# Ip elástico
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "Elastic-Ip-Project"     
  }
}