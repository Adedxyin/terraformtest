output "public_ip" {
  value = aws_instance.frontend[0].public_ip
}