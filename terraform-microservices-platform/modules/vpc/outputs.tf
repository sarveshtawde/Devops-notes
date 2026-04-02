output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private.id]
}

output "isolated_subnet_ids" {
  value = [aws_subnet.isolated.id]
}

output "lambda_sg" {
  value = aws_security_group.lambda_sg.id
}