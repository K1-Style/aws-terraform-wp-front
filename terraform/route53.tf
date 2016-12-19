resource "aws_route53_zone" "wp" {
  name = "${var.bucket_name}"
}

resource "aws_route53_record" "wp" {
  zone_id = "${aws_route53_zone.wp.zone_id}"
  name    = "${var.bucket_name}"
  type    = "A"

  alias {
    name    = "${aws_cloudfront_distribution.wp.domain_name}"
    zone_id = "${aws_cloudfront_distribution.wp.hosted_zone_id}"
    evaluate_target_health = false
  }
}
