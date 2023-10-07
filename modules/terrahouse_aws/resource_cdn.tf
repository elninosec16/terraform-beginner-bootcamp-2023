#ClourdFront Origin Access Control (OAC) configuration:
resource "aws_cloudfront_origin_access_control" "s3_bucket_oac" {
  name                              = "aws CloudFront OAC ${var.s3_bucket_name}"
  description                       = "TerraHouse S3 static website hosting OAC ${var.s3_bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


#CloudFront configuration:
resource "aws_cloudfront_distribution" "s3_bucket_distribution" {
  origin {
    domain_name              = aws_s3_bucket.s3-btcamp-tst.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 bucket static website hosting ${var.s3_bucket_name}"
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

#CloudFront distribution terraform_data config
resource "terraform_data" "invalidate_cache" {
  triggers_replace = terraform_data.content_version.output
  
  provisioner "local-exec" {
    command = <<COMMAND
      aws cloudfront create-invalidation \
      --distribution-id \
      ${aws_cloudfront_distribution.s3_bucket_distribution.id} \ 
      --paths '/*'
    COMMAND
    
  }
}