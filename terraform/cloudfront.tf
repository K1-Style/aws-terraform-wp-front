# CloudFront origin_access_identity
resource "aws_cloudfront_origin_access_identity" "wp" {
  comment = "${var.bucket_name}"
}

data "template_file" "wp_s3_policy" {
  template = "${file("${path.module}/policies/wp_s3_policy.json.tpl")}"

  vars {
    bucket_name            = "${var.bucket_name}"
    origin_access_identity = "${aws_cloudfront_origin_access_identity.wp.id}"
  }
}

# CloudFront
resource "aws_cloudfront_distribution" "wp" {
  enabled             = true
  comment             = "${var.bucket_name}"
  default_root_object = "${var.index}"
  price_class         = "PriceClass_200"
  retain_on_delete    = true
  aliases = ["${var.bucket_name}"]

  origin {
    domain_name = "${aws_s3_bucket.wp.id}.s3.amazonaws.com"
    origin_id   = "${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.wp.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.wp.id}"
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.acm_certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}
