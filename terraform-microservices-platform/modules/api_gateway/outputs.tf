output "public_api_url" {
  value = aws_api_gateway_rest_api.public_api.execution_arn
}