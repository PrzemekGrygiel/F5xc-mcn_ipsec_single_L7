data "aws_caller_identity" "current" {}

resource "aws_vpc_peering_connection" "peer-1-2" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = aws_vpc.pg-vpc2.id
  #peer_region   = var.aws_region
  vpc_id        = aws_vpc.pg-vpc1.id
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-1-2.id
  auto_accept               = true
}
