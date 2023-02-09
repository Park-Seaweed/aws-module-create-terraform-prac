output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}
output "ec2_id" {
  value = aws_instance.ec2[*].id
}
