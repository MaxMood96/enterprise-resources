resource "aws_subnet" "ec2_subnet" {
  vpc_id            = data.terraform_remote_state.cluster.outputs.vpc["vpc_id"]
  availability_zone = var.availability_zone
  cidr_block        = cidrsubnet(var.subnet_ip, 4, 1)
}

data "aws_route_table" "ec2" {
  vpc_id         = data.terraform_remote_state.cluster.outputs.vpc["vpc_id"]
  route_table_id = data.terraform_remote_state.cluster.outputs.vpc["private_route_table_ids"][0]
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.ec2_subnet.id
  route_table_id = data.aws_route_table.ec2.id
}