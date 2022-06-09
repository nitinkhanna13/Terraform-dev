  terraform {
    backend "s3" {
      bucket  = "terrformtest"
      key     = "tf-states-files/s3/terraform.tfstate"
      region  = "us-east-1"
      encrypt = "true"
      #dynamodb_table = "s3-state-lock" # Statefile locking    
    }

    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = ">= 2.0"
      }
      random = {
        source = "hashicorp/random"
      }
    }
  }

  provider "aws" {
    region = var.region
    default_tags {
      tags = {
        terraform = "true"
      }
    }
  }

  provider "aws" {
    alias  = "usw2"
    region = "us-west-2"
    # tags = {
    #   terraform = "true"
    # }
  }

  module "label" {
    source  = "cloudposse/label/null"
    version = "0.25.0"

    namespace   = var.namespace
    environment = var.environment
    label_order = ["environment", "namespace", "name", "attributes"]
    tags = {
      "Workspace" = terraform.workspace
    }
  }


  ##########################################################

data "terraform_remote_state" "globals" {
  backend = "s3"
  config  = {
      bucket  = "terrformtest"
      key     = "tf-states-files/ecr/terraform.tfstate"
      region  = "us-east-1"
  }
}
