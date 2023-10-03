# Terraform Beginner Bootcamp 2023

## Week 1 Project Diagram

![Week 1 Project Diagram](/pics/Week0.png)

## Week 1 - Table of Contents

### Terraform Module Project Structure[^1]

- variables.tf
- outputs.tf
- main.tf
- providers.tf
- terraform.tfvars
- README.md

### Terraform Modules Definition[^2]

| File Name | Description |
| --- | --- |
| variables | store input variables |
| main.tf  | main file |
| providers.tf | providers configuration |
| outputs.tf | store outpus values |
| terraform.tf | variables defenition |
| README.md | required for the root modules |


### Terraform Import and Config Drift

During this section, there was some issues with the terraform state file. In order to recover it, the current aws resource should be imported using the `terraform import` for the S3 bucket[^3]. The `ramdon AWS provider` config was also updated with new variables config.

#### Terraform variable and validation config
```terrafrom
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
```

### Support Links:

[^1]:[Terraform Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

[^2]:[Terraform Inputs Variable](https://developer.hashicorp.com/terraform/language/values/variables)

[^3]:[How to import aws_S3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)