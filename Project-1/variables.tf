
variable "region" {
  type = string
}

variable "environment" {}
variable "vpc_name_tag" {}
variable "cidr_blocks" {}



#DB
variable "db_port" {}
variable "db_name"{}
variable "db_storage_min"{}
variable "db_storage_max"{}
variable "db_instance_class"{}
variable "log_retention"{}
variable "db_engine"{}
variable "db_engine_version"{}
variable "instance_type" {}
variable "custom_domain"{}


variable "secret_manager_name"{}
variable "lambda_runtime" {
  type= string
}
variable "db_username"{
  description = "Database administrator username"
  type        = string
  sensitive   = true
}
variable "app_api_key"{
  description = "client api key"
  type        = string
  sensitive   = true
}
variable "db_password"{
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

