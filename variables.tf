variable "aws_region" {
  default = "eu-central-1"
}

variable "bucket_name" {
  description = "S3 bucket name for my static website hosting"
  type = string
}