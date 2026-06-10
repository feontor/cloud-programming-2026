resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "index.html"
  source       = "website/index.html"
  content_type = "text/html"
  acl          = "public-read"

  depends_on = [
    aws_s3_bucket_acl.bucket_acl,
    aws_s3_bucket_public_access_block.public_access,
    aws_s3_bucket_ownership_controls.ownership
  ]
}

resource "aws_s3_object" "seal_image" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "tulenistock.jpg"           
  source       = "website/tulenistock.jpg"   
  content_type = "image/jpeg"
  acl          = "public-read"

  depends_on = [
    aws_s3_bucket_acl.bucket_acl,
    aws_s3_bucket_public_access_block.public_access,
    aws_s3_bucket_ownership_controls.ownership
  ]
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_cloudfront_distribution" "cdn" {

  price_class = "PriceClass_All"
  
  origin {
    domain_name = "${var.bucket_name}.s3-website.eu-central-1.amazonaws.com"
    origin_id   = "S3-Website-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]

    cached_methods = ["GET", "HEAD"]

    target_origin_id = "S3-Website-Origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}