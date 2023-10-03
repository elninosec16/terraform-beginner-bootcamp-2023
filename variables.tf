variable "user_uuid" {
  description  = "The UUID of the uer"
  type         = string

}

variable "terraform" {
  description = "terraform manage resource"
  type    = string
  default = "True"
}

variable "project_name" {
  description = "Project name definition"
  type        = string
  default     = "TF BootCamp Beginner 2003"
}

variable "btcamp_bucket_name" {
  description = "The name of the S3 bucket name"
  type        = string
  
  validation {
    condition = (
      length(var.btcamp_bucket_name) >= 3 && length(var.btcamp_bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.btcamp_bucket_name))
    )
    
    error_message = "The bucket name must be between 3 and 63 characters"
  }
}