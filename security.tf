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
}

