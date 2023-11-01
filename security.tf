resource "aws_security_group" "management" {
  name        = "management_sg"
  description = "Allow inbound management traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from Jenkins Master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allow inbound  management traffic"
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound traffic to the internet
  }
}


resource "aws_security_group" "k8cluster" {
  name        = "k8cluster_sg"
  description = "Allow inbound k8 traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow 10250"
    from_port   = 0
    to_port     = 65564
    protocol    = "tcp"
    self = "true"
  }


  tags = {
    Name = "Allow inbound  k8 traffic"
  }

}
