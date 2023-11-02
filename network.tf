# create dev vpc

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.1.0/24"

  tags = {

    Name = "dev_vpc"
    Env  = var.Env
  }

}

# create private subnet

resource "aws_subnet" "pub_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.16.1.0/26"
  availability_zone = "us-east-1a"
  tags = {

    Name = "dev_subnet"
    Env  = var.Env
  }
}

resource "aws_subnet" "pub_subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.16.1.64/26"
  availability_zone = "us-east-1b"

  tags = {

    Name = "dev_subnet"
    Env  = var.Env
  }
}




# vpc peering


resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.vpc.id
  peer_vpc_id = "vpc-070a94f0c15512d73"
  auto_accept = true
}

resource "aws_vpc_peering_connection_options" "peering" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id

  # accepter {
  #   allow_remote_vpc_dns_resolution = true
  # }
}


# create igw for dev vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Env = var.Env
  }
}


# route table for public_subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_subnet_rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block                = "172.31.48.0/20"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }


}

# route table association public subnet

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public.id
}


# add route to route table in management (jenkins) vpc

resource "aws_route" "route" {
  route_table_id            = "rtb-0b1a2977fe7ad5e1d"
  destination_cidr_block    = "172.16.1.0/25"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
