# resource "aws_vpc" "monitoring" {
#   cidr_block = "10.0.0.0/16"
# }
# resource "aws_subnet" "monitoring" {
#   vpc_id     = aws_vpc.monitoring.id
#   cidr_block = cidrsubnet(aws_vpc.monitoring.cidr_block, 8, 0)
# }
# resource "aws_internet_gateway" "monitoring" {
#   vpc_id = aws_vpc.monitoring.id
# }
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.monitoring.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.monitoring.id
#   }
# }
# resource "aws_route_table_association" "monitoring" {
#   subnet_id      = aws_subnet.monitoring.id
#   route_table_id = aws_route_table.public.id
# }