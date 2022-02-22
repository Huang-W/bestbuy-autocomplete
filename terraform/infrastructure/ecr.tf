resource "aws_ecr_repository" "bestbuy-web" {
  name = "app/bestbuy-web"
  tags = {}
}

resource "aws_ecr_repository" "golang" {
  name = "devops/golang"
  tags = {}
}

resource "aws_ecr_repository" "kubectl" {
  name = "devops/kubectl"
  tags = {}
}
