resource "aws_security_group" "management" {
  name        = "management_sg"
  description = "allow inbound ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from Jenkins Master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow inbound ssh"
  }
}

# security group to allow k8cluster inbound

resource "aws_security_group" "k8cluster" {
  name        = "k8cluster_inbound"
  description = "allow ingress to k8cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "nginx from alb"
    from_port   = 32028
    to_port     = 32028
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh from jenkins_master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }

ingress {
    description = "intercluster communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = "true"
  }

  tags = {
    Name = "Allow inbound  web traffic"
  }

}

# security group to allow appolcation load balancer inbound

resource "aws_security_group" "alb" {
  name        = "http_inbound_sg"
  description = "Allow inbound http traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "allow http from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port        = 32028
    to_port          = 32028
    protocol         = "tcp"
    security_groups      = [aws_security_group.k8cluster.id]
  }

  tags = {
    Name = "Allow inbound  http traffic"
  }
}
