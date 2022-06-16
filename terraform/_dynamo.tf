#tfsec:ignore:aws-dynamodb-enable-recovery 
resource "aws_dynamodb_table" "tfm_state_lock" {
  name         = var.tfm_state_ddb_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  #tfsec:ignore:aws-dynamodb-table-customer-key
  server_side_encryption {
    enabled = true
  }

}


