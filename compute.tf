
# eni for jenkins ec2

resource "aws_network_interface" "jenkins" {
  subnet_id   = aws_subnet.subnet.id

    tags = {
      Name = "${var.Env}_jen_agent"
      Env = var.Env
      Role = "jenkins"
    }
}

# eni for k8master ec2

resource "aws_network_interface" "k8master" {
  subnet_id   = aws_subnet.subnet.id

    tags = {
      Name = "${var.Env}_k8master"
      Env = var.Env
      Role = "k8master"
    }
}

# eni for k8worker nodes

resource "aws_network_interface" "k8worker" {
  count = 2
  subnet_id   = aws_subnet.subnet.id

    tags = {
      Name = "${var.Env}_k8worker${count.index+1}"
      Env = var.Env
      Role = "k8worker"
    }
}


# ec2 instace for jenkis agent

resource "aws_instance" "jenkins" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.jenkins.id
    device_index         = 0
  }

    tags = {
      Name = "${var.Env}_jen_agent"
      Env = var.Env
      Role = "jenkins"
    }
}


# ec2 instace for k8 master

resource "aws_instance" "k8master" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.k8master.id
    device_index         = 0
  }

    tags = {
      Name = "${var.Env}_k8master"
      Env = var.Env
      Role = "k8master"
    }
}

# ec2 instace for k8 worker nodes

resource "aws_instance" "k8worker" {
  count = 2
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.k8worker[count.index].id
    device_index         = 0
  }

    tags = {
      Name = "${var.Env}_k8worker${count.index+1}"
      Env = var.Env
      Role = "k8worker"
    }
}

# query eni for k8worker nodes to get private ip
data "aws_network_interface" "k8worker" {
  count = 2
  id = aws_network_interface.k8worker[count.index].id
}

# query eni for k8master to get private ip
data "aws_network_interface" "k8master" {
  id = aws_network_interface.k8master.id
}

# query eni for jenkis to get private ip
data "aws_network_interface" "jenkins" {
  id = aws_network_interface.jenkins.id
}
