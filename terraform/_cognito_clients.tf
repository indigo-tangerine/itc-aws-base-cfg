resource "aws_cognito_resource_server" "mvdb" {
  identifier = "${var.client}-mvdb"
  name       = "${var.client}-mvdb"

  scope {
    scope_name        = "m2m"
    scope_description = "machine-machine"
  }
  scope {
    scope_name        = "monitoring"
    scope_description = "monitoring"
  }

  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "mvdb" {
  name = "mvdb-api"

  generate_secret                      = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = aws_cognito_resource_server.mvdb.scope_identifiers
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"

  user_pool_id = aws_cognito_user_pool.main.id
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "mvdb" {
  name = "${var.client}-mvdb"
}

resource "aws_secretsmanager_secret_version" "mvdb" {
  secret_id     = aws_secretsmanager_secret.mvdb.id
  secret_string = jsonencode(local.mvdb_cognito)
}

locals {
  mvdb_cognito = {
    client_id        = aws_cognito_user_pool_client.mvdb.id
    client_secret    = aws_cognito_user_pool_client.mvdb.client_secret
    m2m_scope        = "m2m"
    monitoring_scope = "monitoring"
    endpoint         = aws_cognito_user_pool.main.endpoint
  }
}
