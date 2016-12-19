# S3
resource "aws_s3_bucket" "wp" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"
  force_destroy = true
  policy = "${data.template_file.wp_s3_policy.rendered}"

  website {
    index_document = "${var.index}"
  }
}
