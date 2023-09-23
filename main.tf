#how to use random provider
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}

#random_string to generate random string
resource "random_string" "bucket_name" {
  length           = 16
  special          = false
}

#To display the random_string using TF output command
#output command for this section could be either id or result 
output "random_bucket_name_result" {
  value = random_string.bucket_name.result
}
