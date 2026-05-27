locals {
  default_tags = {
    "environment" = "dev"
    "managed"     = "terraform"
  }
  default_origin = "*"
}

resource "aws_s3_bucket" "general_purpose_bucket" {
  bucket           = "${var.bucket-prefix}-${local.default_tags.environment}-bucket"
  bucket_namespace = var.optional_region != "" ? "${var.optional_region}" : null

  tags = merge(
    {
      name    = "${var.bucket-prefix}-${local.default_tags.environment}-bucket"
      service = "${var.service_type}"
    },
    local.default_tags
  )
}

resource "aws_s3_bucket_cors_configuration" "general_purpose_bucket_cors" {
  count  = var.cors_specified != 0 ? 1 : 0
  bucket = aws_s3_bucket.general_purpose_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = coalesce(format("https://%s", var.origin_string), local.default_origin)
    max_age_seconds = 3000
  }
}
