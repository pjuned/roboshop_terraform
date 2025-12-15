terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }

  
  backend "s3" {
    bucket = "76-remote-state"
    key    = "sg"
    region = "us-east-1"
    dynamodb_table = "76-locking"
  }


}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}