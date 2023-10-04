#To display the random_string using TF output command
#output command for this section could be either id or result 
output "btcamp_bucket_name" {
  value = module.terraform_aws.btcamp_bucket_name
  
}