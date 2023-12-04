# Associar as subnets publicas criadas
# ---- Public Routeing Table ----
resource "aws_route_table_association" "public-1" {

  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.public.id

}