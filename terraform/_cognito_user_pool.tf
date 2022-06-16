resource "aws_cognito_user_pool" "main" {
  name = var.client
}

resource "aws_cognito_user_pool_domain" "main" {
  domain          = "auth.${local.dev_dns_name}"
  certificate_arn = aws_acm_certificate.auth.arn
  user_pool_id    = aws_cognito_user_pool.main.id

  depends_on = [aws_route53_record.dummy]
}

resource "aws_route53_record" "auth" {
  name    = "auth.${local.dev_dns_name}"
  type    = "A"
  zone_id = aws_route53_zone.dev_itc.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_route53_record" "dummy" {
  name    = local.dev_dns_name
  type    = "A"
  zone_id = aws_route53_zone.dev_itc.zone_id
  ttl     = "300"
  records = ["1.2.3.4"]
}
