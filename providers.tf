#how to use random provider
terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "ElninoSec16"

    workspaces {
      name = "tf-beginner-bootcamp-wkspce"
    }
  }
}  

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token     = var.terratowns_access_code
}

provider "aws" {
    
  default_tags {
    tags = {
        user_uuid   = var.teacherseat_user_uuid
        Terraform   = "True"
        Project	    = "TF BootCamp Beginner 2003"
    }
  }
}




