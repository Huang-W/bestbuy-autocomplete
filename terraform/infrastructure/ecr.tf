resource "aws_ecr_repository" "bestbuy-web" {
  name = "app/bestbuy-web"
}

resource "aws_ecr_repository" "golang" {
  name = "ops/golang"
}

resource "aws_ecr_repository" "kubectl" {
  name = "ops/kubectl"
}
