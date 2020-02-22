# peering.tf

data "aws_vpc" "vpcA"{
  provider  = aws.A
  id    = var.subA.vpc_id
}

data "aws_vpc" "vpcB"{
  provider  = aws.B
  id    = var.subB.vpc_id
}

data "aws_caller_identity" userB {
	provider		= aws.B
}

resource "aws_vpc_peering_connection" "con" {
  provider			= aws.A
	vpc_id				= data.aws_vpc.vpcA.id	
	peer_vpc_id		= data.aws_vpc.vpcB.id
	peer_owner_id	= data.aws_caller_identity.userB.account_id
	peer_region		= var.regionB

	auto_accept		= false 
}

resource	"aws_vpc_peering_connection_accepter" "peer_accept" {
	provider									= aws.B
	vpc_peering_connection_id	= aws_vpc_peering_connection.con.id
	auto_accept								= true
}

resource "aws_route" "route_to_b" {
  provider                  = aws.A
  route_table_id            = data.aws_vpc.vpcA.main_route_table_id
  destination_cidr_block    = var.subB.cidr_block 
  vpc_peering_connection_id = aws_vpc_peering_connection.con.id
}

resource "aws_route" "route_to_a" {
  provider                  = aws.B
  route_table_id            = data.aws_vpc.vpcB.main_route_table_id
  destination_cidr_block    = var.subA.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.con.id
}

