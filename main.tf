#how to use random provider
terraform {
  #Old way to configure Terraform Cloud:
  # https://developer.hashicorp.com/terraform/language/settings/backends/remote
  #backend "remote" {
  #  hostname     = "app.terraform.io"
  #  organization = "ElninoSec16"
  #
  #  workspaces {
  #    name = "tf-beginner-bootcamp-wkspce"
  #  }
  #}

  #New way to configure Terraform Cloud:
    cloud {
    organization = "ElninoSec16"

    workspaces {
      name = "tf-beginner-bootcamp-wkspce"
    }
  }
  
  required_providers {
    #TF random provider config
    # https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    #AWS Provider for the S3 config to work
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    } 
  }
}
#**Important provider note**: be sure to perform `terraform init -upgrade` when adding new provider config to the current TF config.

provider "random" {
  # Configuration options
}

#random_string to generate random string
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "bucket_name" {
  lower     = true
  upper     = false
  length    = 32
  special   = false
}

#To display the random_string using TF output command
#output command for this section could be either id or result 
output "random_bucket_name" {
  value = random_string.bucket_name.result
}

#S3 configuration
resource "aws_s3_bucket" "s3-btcamp-tst" {
  #S3 name restriction
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
  bucket = random_string.bucket_name.result

  tags = {
    Name        = "s3-tf-bootcamp-1"
    Environment = "bootcamp-2023"
    Terraform	  = "True"
  }
}
