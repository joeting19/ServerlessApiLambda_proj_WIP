provider "aws" {
  region                   = var.region
  profile                  = "default"
  shared_credentials_files = ["C:/Users/Maitri WInd/.aws/credentials"]
}

provider "aws" {
  region                   = var.region
  profile                  = "awstest19"
  alias                    = "awstest19"
  shared_credentials_files = ["C:/Users/Maitri WInd/.aws/credentialstest19"]
}

