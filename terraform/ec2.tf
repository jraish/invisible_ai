resource "aws_instance" "prometheus_instance" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type

  vpc_security_group_ids = [ aws_security_group.prometheus_security_group.id ]
  subnet_id              = aws_subnet.prometheus_subnet.id

  user_data                   = data.cloudinit_config.prmthus_service.rendered

  tags = {
    Name = "leader_instance"
  }
}