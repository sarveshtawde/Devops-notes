module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
}

module "endpoints" {
  source  = "./modules/endpoints"
  vpc_id  = module.vpc.vpc_id
}

module "lambda_private" {
  source            = "./modules/lambda"
  function_name     = "private-lambda"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.vpc.lambda_sg
  role_arn          = module.iam.lambda_role_arn
}

module "lambda_isolated" {
  source            = "./modules/lambda"
  function_name     = "isolated-lambda"
  subnet_ids        = module.vpc.isolated_subnet_ids
  security_group_id = module.vpc.lambda_sg
  role_arn          = module.iam.lambda_role_arn
}

module "api_gateway" {
  source = "./modules/api_gateway"

  private_lambda_arn  = module.lambda_private.lambda_arn
  isolated_lambda_arn = module.lambda_isolated.lambda_arn
}

module "waf" {
  source = "./modules/waf"
}