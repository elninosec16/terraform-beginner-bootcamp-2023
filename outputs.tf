#To display the random_string using TF output command
#output command for this section could be either id or result 
output "random_bucket_name" {
  value = random_string.bucket_name.result
}