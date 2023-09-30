# create vpc

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.1.0/24"

  tags   = {

    Name  = "dev_vpc"
    Env  = "dev"
  }

}


# create subnet

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.1.0/26"

  tags   = {

    Name  = "dev_subnet"
    Env  = "dev"
  }
}


# vpc peering


resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.vpc.id
  peer_vpc_id = "vpc-01b068a477baa5e42"
  auto_accept = true
}

resource "aws_vpc_peering_connection_options" "peering" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}


# route table for dev vpc

resource "aws_route_table" "dev" {
  vpc_id = aws_vpc.vpc.id

  tags   = {
    Name  = "dev_subnet_rt"
  }

  route {
    cidr_block = "172.16.0.0/26"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }

}

# route table assosiation dev subnet

resource "aws_route_table_association" "dev" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.dev.id
}


# aad route to route table in management (jenkins) vpc

resource "aws_route" "route" {
  route_table_id            = "rtb-0158457a6faac9304"
  destination_cidr_block    = "172.16.1.0/26"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

