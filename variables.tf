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