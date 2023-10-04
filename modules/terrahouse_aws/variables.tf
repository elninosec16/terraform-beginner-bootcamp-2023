variable "user_uuid" {
  description  = "The UUID of the uer"
  type         = string
  
}

variable "terraform" {
  description = "terraform manage resource"
  type        = string
   
}

variable "project_name" {
  description = "Project name definition"
  type        = string
   
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket name"
  type        = string
  
  validation {
    condition = (
      length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.s3_bucket_name))
    )
    
    error_message = "The bucket name must be between 3 and 63 characters"
  }
}

variable "index_html_filepath" {
  description = "The file path for index.html"
  type        = string
  
  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The provided apth for index.html does not exist." 
  }
}

variable "error_html_filepath" {
  description = "The file path for error.html"
  type        = string
  
  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The provided apth for index.html does not exist." 
  }
}