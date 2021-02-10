###############################################################
# IAM
###############################################################
output "aws_load_balancer_iam_policy" {
  value = aws_iam_policy.policy.arn
}
###############################################################


###############################################################
# ECR
###############################################################
output "ecr_url" {
  description = "your private registry url for this region"
  value       = data.aws_ecr_authorization_token.bestbuy.proxy_endpoint
}
output "ecr_repo_bestbuy" {
  value = aws_ecr_repository.bestbuy.name
}
output "ecr_repo_elastic" {
  value = aws_ecr_repository.elastic_indexer.name
}
###############################################################


###############################################################
# EKS
###############################################################
output "eks_elastic_endpoint" {
  value = data.aws_eks_cluster.elastic.endpoint
}
output "eks_elastic_ca_cert" {
  value     = data.aws_eks_cluster.elastic.certificate_authority.0.data
  sensitive = true
}
output "eks_elastic_oidc_issuer_url" {
  value = module.eks_elastic.cluster_oidc_issuer_url
}
output "eks_web_endpoint" {
  value = data.aws_eks_cluster.web.endpoint
}
output "eks_web_ca_cert" {
  value     = data.aws_eks_cluster.web.certificate_authority.0.data
  sensitive = true
}
output "eks_web_oidc_issuer_url" {
  value = module.eks_web.cluster_oidc_issuer_url
}
###############################################################


###############################################################
# Key-pair
###############################################################
output "jumpbox_key_pair_fingerprint" {
  value = module.key_pair_jumpbox.this_key_pair_fingerprint
}
output "jumpbox_key_pair_private_pem" {
  value     = tls_private_key.a.private_key_pem
  sensitive = true
}
output "elastic_key_pair_fingerprint" {
  value = module.key_pair_elastic.this_key_pair_fingerprint
}
output "elastic_key_pair_private_pem" {
  value     = tls_private_key.b.private_key_pem
  sensitive = true
}
output "web_key_pair_fingerprint" {
  value = module.key_pair_web.this_key_pair_fingerprint
}
output "web_key_pair_private_pem" {
  value     = tls_private_key.c.private_key_pem
  sensitive = true
}
###############################################################


output "jumpbox_public_ip" {
  value = module.jumpbox.public_ip
}

output "aws_region" {
  value = var.region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_elastic" {
  value = var.eks_elastic
}

output "eks_web" {
  value = var.eks_web
}