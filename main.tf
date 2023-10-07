resource "aws_s3_bucket" "my_bucket" {
  bucket = "manoj53812"  # Replace with your desired bucket name
  acl    = "private"  # You can adjust the access control here

  versioning {
    enabled = true
  }
}

# Create an S3 Bucket Object (Upload an Example HTML File)
resource "aws_s3_bucket_object" "website" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = "C:\Users\magantha\index.html"  # Replace with the path to your HTML file
  content_type = "text/html"
}

# Create a CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.my_bucket.website_endpoint
    origin_id   = "s3_origin"

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_origin"

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

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Outputs
output "s3_bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
