terraform {
  backend "s3" {
    bucket         = "credpal-terraform-backendstate"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}