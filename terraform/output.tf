# output "leader_ip_address" {
#   value = aws_instance.leader_node.public_ip
# }

# output "follower_ip_address" {
#   value = aws_instance.follower_node.public_ip
# }

output "prmthus_pub_dns" {
  description = "AWS public dns of ec2."
  value       = { for ec2_inst in aws_instance.prometheus_instance[*] : ec2_inst.tags.Name => ec2_inst.public_ip }
}
