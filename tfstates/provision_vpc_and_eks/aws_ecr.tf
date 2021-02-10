###############################################################
# ECR - web container images
###############################################################
resource "aws_ecr_repository" "bestbuy" {
  name                 = "bestbuy"
  image_tag_mutability = "IMMUTABLE"
}
resource "aws_ecr_repository_policy" "ecr_policy_bestbuy" {
  repository = aws_ecr_repository.bestbuy.name
  policy     = data.aws_iam_policy_document.ecr_policy.json
}
data "aws_ecr_authorization_token" "bestbuy" {}
###############################################################


###############################################################
# ECR - stores one image for a one-off job to index the elasticsearch cluster
###############################################################
resource "aws_ecr_repository" "elastic_indexer" {
  name                 = "elastic_indexer"
  image_tag_mutability = "IMMUTABLE"
}
resource "aws_ecr_repository_policy" "ecr_policy_elastic" {
  repository = aws_ecr_repository.elastic_indexer.name
  policy     = data.aws_iam_policy_document.ecr_policy.json
}
data "aws_ecr_authorization_token" "elastic_indexer" {}
###############################################################


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
    effect = "Allow"

    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}
