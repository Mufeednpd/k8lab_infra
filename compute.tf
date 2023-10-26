



# eni for k8master ec2

resource "aws_network_interface" "k8master" {
  subnet_id = aws_subnet.pub_subnet.id

  tags = {
    Name = "${var.Env}_k8master"
    Env  = var.Env
    Role = "k8master"
  }

}

# security group attachment for k8master

resource "aws_network_interface_sg_attachment" "k8master" {
  security_group_id    = aws_security_group.management.id
  network_interface_id = aws_network_interface.k8master.id
}

# eni for k8worker nodes

resource "aws_network_interface" "k8worker" {
  count     = 2
  subnet_id = aws_subnet.pub_subnet.id

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}

# security group attachment for k8worker

resource "aws_network_interface_sg_attachment" "k8worker" {
  count                = 2
  security_group_id    = aws_security_group.management.id
  network_interface_id = aws_network_interface.k8worker[count.index].id
}


# ec2 instace for jenkis agent

resource "aws_instance" "jenkins" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name      = "newkey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [

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
  vpc_security_group_ids

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

resource "aws_instance" "k8worker" {
  count         = 2
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "newkey"
  associate_public_ip_address = "true"

 subnet_id = aws_subnet.pub_subnet.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}

# query eni for k8worker nodes to get private ip
data "aws_instance" "k8worker" {
  count = 2
  instance_id    = aws_instance.k8worker[count.index].id
}

# query eni for k8master to get private ip
data "aws_instance" "k8master" {
  instance_id = aws_instance.k8master.id
}

# query eni for jenkis to get private ip
data "aws_instance" "jenkins" {
 instance_id = aws_instance.jenkins.id
}
