output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_api_url" {
  value = module.api_gateway.public_api_url
}