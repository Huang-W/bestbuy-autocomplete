###############################################################
# Identifies the EKS elastic cluster
###############################################################
data "tls_certificate" "example" {
  url = data.terraform_remote_state.vpc.outputs.eks_elastic_oidc_issuer_url
}
resource "aws_iam_openid_connect_provider" "default" {
  url = data.terraform_remote_state.vpc.outputs.eks_elastic_oidc_issuer_url
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
}
###############################################################


###############################################################
# Allows the EKS cluster to create Load Balancers using the AWS API
###############################################################
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.vpc.outputs.eks_elastic_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = ["sts.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "aws_iam_role" "aws_load_balancer_controller" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}
resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = data.terraform_remote_state.vpc.outputs.aws_load_balancer_iam_policy
}
###############################################################
