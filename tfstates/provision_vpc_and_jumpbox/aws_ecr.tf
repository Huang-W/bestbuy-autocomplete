resource "aws_ecr_repository" "bestbuy" {
  name                 = "bestbuy"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.bestbuy.name
  policy = data.aws_iam_policy_document.ecr_policy.json
}

data "aws_ecr_authorization_token" "bestbuy" {}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
    effect  = "Allow"

    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}
