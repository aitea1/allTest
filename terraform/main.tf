module common {
  source = "./modules/common"
  aws_account_id = var.aws_account_id
  s3_bucket_arn = module.data.s3_bucket_arn
}

module compute  {
  source = "./modules/compute"
  lambda_execution_role_arn = module.common.lambda_execution_role_arn
  aws_account_id = var.aws_account_id
}

module data{
    source = "./modules/data"
}