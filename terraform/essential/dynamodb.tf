resource "aws_dynamodb_table" "terraform-state-locking" {
  name           = "terraform-state-locking"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"
  stream_enabled = false

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-terraform-remote-state-backup"
    Type = "database"
  })
}
