terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
  }
  
#   backend "s3" {
#     bucket         = "remote-backend-s3-2210"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"  # Update with your desired region
#     dynamodb_table = "terraform-lock-table"  # Optional: Enable DynamoDB table for state locking
#     encrypt        = true
#   }
}




provider "aws" {
  # Configuration options
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"  # Update with your desired AWS region
}