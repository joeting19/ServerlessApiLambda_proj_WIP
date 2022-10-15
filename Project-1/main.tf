# terraform plan --var-file=variables/test.tfvars

module "vpc" {
  source       = "../Modules/vpc"
  vpc_name_tag = var.vpc_name_tag
  cidr_blocks  = var.cidr_blocks
}

module "sgs" {
  source       = "../Modules/sgs"
  vpc_id  = module.vpc.vpc_id
  db_port=var.db_port
  cidr_blocks  = var.cidr_blocks
}

module "lambda" {
  source = "../Modules/lambda"
  privsubnet1_id=module.vpc.privsubnet1_id
  privsubnet2_id=module.vpc.privsubnet2_id
  secret_kms_keyArn=module.db.secret_kms_keyArn
  db_secrets_arn=module.db.db_secrets_arn
  sg_id_lambda=module.sgs.sg_id_lambda 
  lambda_runtime=var.lambda_runtime
  log_retention=var.log_retention
}

module "apigw" {
  source          = "../Modules/apigw"
  custom_domain=var.custom_domain
  app_api_key=var.app_api_key
  environment=var.environment
  log_retention=var.log_retention
  app_lambda_uri  = module.lambda.app_lambda_uri
  app_lambda_name = module.lambda.app_lambda_name
}


module "db" {
 source="../Modules/db"
 secret_manager_name=var.secret_manager_name
 log_retention=var.log_retention
 db_username=var.db_username
 db_password=var.db_password
 db_instance_class=var.db_instance_class
 db_storage_min=var.db_storage_min
 db_storage_max=var.db_storage_max
 db_name=var.db_name
 dbsg_id=module.sgs.dbsg_id
 db_engine=var.db_engine
 db_engine_version=var.db_engine_version
 privsubnet3_id= module.vpc.privsubnet3_id
 privsubnet4_id= module.vpc.privsubnet4_id  
}



