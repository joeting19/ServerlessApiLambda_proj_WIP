variable "app_lambda_uri" {}
variable "app_lambda_name"  {}
variable "environment"  {}
variable "log_retention" {}
variable "app_api_key"{
  description = "api key"
  type        = string
  sensitive   = true
}

variable "custom_domain" {}