resource "aws_route53_zone" "dev_itc" {
  name = local.dev_dns_name
}
