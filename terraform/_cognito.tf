module "cognito_user_pool" {
  source = "github.com/indigo-tangerine/terraform-aws-itc-cognito-user-pool?ref=v1.1.0"
  # source = "../../terraform-aws-itc-cognito-user-pool"


  user_pool_name = "itc-m2m"

  user_pool_add_ons = {
    advanced_security_mode = "ENFORCED"
  }

  domain                   = local.dev_dns_name
  domain_hostname          = "auth"
  domain_certificate_arn   = aws_acm_certificate.auth.arn
  create_custom_dns_record = true
  amz_domain_prefix        = local.dev_dns_name
  create_dummy_record      = true

  clients = [{
    name                                 = "mvdb-api"
    generate_secret                      = true
    allowed_oauth_flows                  = ["client_credentials"]
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_scopes                 = ["m2m", "monitoring"]
    supported_identity_providers         = ["COGNITO"]
    prevent_user_existence_errors        = "ENABLED"
  }]
}


