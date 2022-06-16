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
  allowed_oauth_scopes                 = aws_cognito_resource_server.mvdb.scope_identifiers #["m2m"] #["m2m", "monitoring"]
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"

  user_pool_id = aws_cognito_user_pool.main.id
}
