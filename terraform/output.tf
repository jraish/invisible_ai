output "leader_instance_id" {
  value = aws_instance.prometheus_leader.id
}

output "leader_instance_public_ip" {
  value = aws_instance.prometheus_leader.public_ip
}