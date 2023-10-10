#how to use random provider
terraform {
    cloud {
    organization = "ElninoSec16"

    workspaces {
      name = "tf-beginner-bootcamp-wkspce"
    }
  }
}  

provider "aws" {
    
  default_tags {
    tags = {
        user_uuid   = var.user_uuid
        Terraform   = "True"
        Project	    = "TF BootCamp Beginner 2003"
    }
  }
}
