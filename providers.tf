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