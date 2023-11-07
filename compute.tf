


# ec2 instace for jenkis agent

resource "aws_instance" "jenkins" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name      = "newkey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.management.id]

 subnet_id = aws_subnet.pub_subnet.id

  tags = {
    Name = "${var.Env}_jen_agent"
    Env  = var.Env
    Role = "jenkins"
  }
}


# ec2 instace for k8 master

resource "aws_instance" "k8master" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name      = "newkey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.management.id,aws_security_group.k8cluster.id]

  subnet_id = aws_subnet.pub_subnet.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }


  tags = {
    Name = "${var.Env}_k8master"
    Env  = var.Env
    Role = "k8master"
  }
}

# ec2 instace for k8 worker nodes


resource "aws_instance" "k8workers_az_a" {
  count         = 1
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "newkey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.management.id,aws_security_group.k8cluster.id]
 subnet_id = aws_subnet.pub_subnet.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 15
    delete_on_termination = true
  }

  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname "k8worker${count.index+1}"
  EOF

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}

resource "aws_instance" "k8workers_az_b" {
  count         = 1
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "newkey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.management.id,aws_security_group.k8cluster.id]
 subnet_id = aws_subnet.pub_subnet.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 15
    delete_on_termination = true
  }

  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname "k8worker${count.index+2}"
  EOF

  tags = {
    Name = "${var.Env}_k8worker${count.index + 2}"
    Env  = var.Env
    Role = "k8worker"
  }
}


# query EC2 for k8worker nodes in AZ a to get private ip
data "aws_instance" "k8workers_az_a" {
  count = 1
  instance_id    = aws_instance.k8workers_az_a[count.index].id
}

# query EC2 for k8worker nodes in AZ b to get private ip
data "aws_instance" "k8workers_az_b" {
  count = 1
  instance_id    = aws_instance.k8workers_az_b[count.index].id
}

# query EC2  for k8master to get private ip
data "aws_instance" "k8master" {
  instance_id = aws_instance.k8master.id
}

# query EC2 for jenkins to get private ip
data "aws_instance" "jenkins" {
 instance_id = aws_instance.jenkins.id
}
