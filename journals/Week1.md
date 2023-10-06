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
### How to refer outputs values from nested modules

After main modules migration, the outputs values required to be passed from one module to the other. This is the tructure of the output module configuration:

```tf
output "butcket_name" {
  description = "S3 Bucket name for static web hosting"
  valude = module.terrahouse_aws.bucket_name
}
```
>[Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)


### New Terraform commands used until now

```tf
terraform apply -refresh-only -auto-approve
```
[Command: refresh](https://developer.hashicorp.com/terraform/cli/commands/refresh)


### S3 bucket website configuration:

#### Create new foler called `public` for the website static html files

|--|__ public
|    |__ index.html 
|    |__ error.html

#### Create the Terraform config for the S3 Bucket website content files 
[Resource: aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

```tf
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

 #routing rule is not required for this config
 # routing_rule {
 #   condition {
 #     key_prefix_equals = "docs/"
 #   }
 #   redirect {
 #     replace_key_prefix_with = "documents/"
 #   }
 # }
}
```

#### Create the Terraform S3 bucket object configuration to reference the S3 Bucekt static website file path location:
[Resource: aws_s3_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)

```tf
resource "aws_s3_object" "object" {
  bucket = "your_bucket_name"
  key    = "new_object_key"
  source = "path/to/file"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("path/to/file")
}
```
>Terraform Registry config example
[](https://developer.hashicorp.com/terraform/language/expressions/references)


#### Update the current TerraHouse modules to declare and to use the S3 Bucket variables with file path validation

- variable.tf <root module>
```tf
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

```

- variable.tf on the `nested module`
```tf
variable "index_html_filepath" {
  description = "The file path for index.html"
  type        = string
  
}

variable "error_html_filepath" {
  description = "The file path for error.html"
  type        = string
  
}

```

#### Update the variable.tfvars on both `root and nested module`
```tf
index_html_filepath="<file-path>"
error_html_filepath="<file-path>"
```

#### Reference the new S3 Bucket website config and object on the main.tf files.

- main.tf on the `nested module`
```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  
  #add the following two lines to pass this variables to the nested module.
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  
}

```

#### Update the storage.tf `main root file`

The AWS S3 website site and object configuration need to be declared and configured in the main.tf on both the root and nested modules.

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index.html_html_filepath
  
  etag   = filemd5(var.error_html_filepath)
}

resource "aws_s3_object" "error_html" {
  bucket  = aws_s3_bucket.website_bucket.bucket
  key     = "error.html"
  source  = var.error_html_filepath
  
  etag    = filemd5(var.error_html_filepath)
}
```

[How to delete local and remote tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

- To correct tagging on previous branches

In order to correct previous tags on branches, you need to find the commit/push `SHA` information on the GitHub in be able to bring the branch back and then retag the branch.


```git
git checkuot <branch-commit-SHA>
git tag <new-tag-name>
pith push --tags
git checkout main
```

1. Add `content_type` on both `object_index.html` and `object_error_html`
```tf
resource "aws_s3_object" "index.html" {
  content_type = "text/html"
}

```


2. CloudFornt Distribution[^4]
```tf
resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

```
#### CloudFront Distribution for TerraTown:
```tf
resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_bucket_distribution" {
  origin {
    domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 bucket static website hosting ${var.<bucket_name>}"
  default_root_object = "index.html"

  #this will be used if decide to use custom domains
  #aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
 
 #price class for CloudFront use.
 price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

```


3. CloudFront Origin Access Control (OAC)[^5]
```tf
resource "aws_cloudfront_origin_access_control" "s3_bucket_oac" {
  name                              = "aws CloudFront OAC ${var.<bucket_name>}"
  description                       = "TerraHouse S3 static website hosting OAC ${var.<bucekt_name>}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```

4. S3 Bucket Policy:
```tf
#aws s3 bucket configuration
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}
```

- S3 Bucket Policy example:

```tf
resource "aws_iam_policy" "policy" {
  name        = "${random_pet.pet_name.id}-policy"
  description = "My test policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}"
    }
  ]

}
EOT
}
```
- S3 Bucket policy for TerraTown Project:
```tf
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "${random_pet.pet_name.id}-policy"
  description = "TerraHouse S3 bucket policy"

  policy = jsonencode({
  "Version" =  "2012-10-17",
  "Statement" = {
      "Sid": "AllowCloudFrontServicePrincipalReadOnly",
      "Effect": "Allow",
      "Principal": {
         "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
      "Condition": {
      "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.<data_source_id_name>.acount.id}:distribution/<data_source_distribution_id_name>"
        }
      },
    }
})
}
```
5. Terraform Data Sources[^7]:

AWS Called ID data source to get the AWS account id[^8]. This config could be copied on the main.tf root file.

```tf
data "aws_caller_identity" "<data_source_name>" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
```

5.1. Working with Json on Terraform config[^9]

The `jsonencode` function was used on bulding the S3 bucket policy. 

```tf
jsonencode({"hello"="world"})
{"hello":"world"}
```

#### Terraform or Git new commands

- Delete tags
```git
#to remove local Git tag
git tag -d <tag-name>

#to list tags
git tag -l

#to remove remote Git tag
git push --delete origin <tag-name>

#to remove remote tag using push command
git push origin :refs/tags/<tag-name>

```

### Support Links:

[^1]:[Terraform Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

[^2]:[Terraform Inputs Variable](https://developer.hashicorp.com/terraform/language/values/variables)

[^3]:[How to import aws_S3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

[^4]:[Resource: aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)

[^5]:[Resource: aws_cloudfront_origin_access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control)

[^6]:[Resource: aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)

[^7]:[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

[^8]:[Data Source:aws_called_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)

[^9]:[jsonencode Function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)