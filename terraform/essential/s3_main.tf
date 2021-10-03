resource "aws_s3_bucket" "terraform-remote-state" {
  bucket = "${var.environment_name}-${var.region}-terraform-remote-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  replication_configuration {
    role = aws_iam_role.terraform-remote-state-replication-role.arn
    rules {
      priority = "1"
      id       = "terraform-state-replication-from-us-west-2-to-us-east-1"
      filter {
        tags = {}
      }
      status = "Enabled"
      destination {
        bucket = aws_s3_bucket.terraform-remote-state-backup.arn
      }
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-terraform-remote-state"
    Type = "storage"
  })
}

resource "aws_iam_role" "terraform-remote-state-replication-role" {
  name               = "terraform-remote-state-replication-role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.s3-assume-role-policy.json
  inline_policy {
    name   = "terraform-remote-state-replication-policy"
    policy = data.aws_iam_policy_document.terraform-remote-state-replication-policy.json
  }
}


data "aws_iam_policy_document" "s3-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "terraform-remote-state-replication-policy" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.environment_name}-${var.region}-terraform-remote-state"
    ]
  }
  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "arn:aws:s3:::${var.environment_name}-${var.region}-terraform-remote-state/*"
    ]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [
      "${aws_s3_bucket.terraform-remote-state-backup.arn}/*"
    ]
  }
}
