resource "aws_organizations_organization" "main" {
  aws_service_access_principals = []

  feature_set = "ALL"
}

