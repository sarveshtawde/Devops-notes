resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename = "lambda.zip"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }
}