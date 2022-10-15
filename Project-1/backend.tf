terraform {
  backend "s3" {
    bucket         = "terraform-statefiles-ahjoe"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    profile        = "default"
    dynamodb_table = "terraform-project"
  }
}