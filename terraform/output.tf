output "leader_ip_address" {
  value = aws_instance.leader_node.public_ip
}

output "follower_ip_address" {
  value = aws_instance.follower_node.public_ip
}