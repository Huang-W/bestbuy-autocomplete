resource "aws_s3_bucket" "terraform-remote-state-backup" {
  provider = aws.backup
  bucket   = "${var.environment_name}-${var.region}-terraform-remote-state-backup"
  acl      = "private"

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

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-terraform-remote-state-backup"
    Type = "storage"
  })
}

resource "aws_s3_bucket_policy" "terraform-remote-state-backup" {
  provider = aws.backup
  bucket   = aws_s3_bucket.terraform-remote-state-backup.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid    = "Permissions on objects"
        Effect = "Allow"
        Principal = {
          "AWS" = aws_iam_role.terraform-remote-state-replication-role.arn
        }
        Action = [
          "s3:ReplicateDelete",
          "s3:ReplicateObject"
        ]
        Resource = "${aws_s3_bucket.terraform-remote-state-backup.arn}/*"
      },
      {
        Sid    = "Permissions on bucket"
        Effect = "Allow"
        Principal = {
          "AWS" = aws_iam_role.terraform-remote-state-replication-role.arn
        }
        Action = [
          "s3:List*",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning"
        ]
        Resource = aws_s3_bucket.terraform-remote-state-backup.arn
      }
    ]
  })
}
