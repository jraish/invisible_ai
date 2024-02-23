resource "aws_key_pair" "monitoring_key" {
  key_name   = "monitoring_key"
  public_key = file("../monitoring_key.pub")
}

resource "aws_instance" "follower_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.monitoring_key.key_name
  vpc_security_group_ids = [aws_security_group.monitoring.id]

  tags = {
    Name = "follower_node"
  }
}

resource "aws_instance" "leader_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.monitoring_key.key_name
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  # depends_on = [ aws_instance.follower_node ]

  tags = {
    Name = "leader_node"
  }
#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u ec2-user -i '${self.public_ip},${aws_instance.follower_node.public_ip}' ../ansible/playbook.yml"
#   }
}