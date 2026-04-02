resource "aws_api_gateway_rest_api" "public_api" {
  name = "public-api"
}

resource "aws_api_gateway_rest_api" "private_api" {
  name = "private-api"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}