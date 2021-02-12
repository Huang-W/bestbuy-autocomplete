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
output "eks_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}
output "eks_ca_cert" {
  value     = data.aws_eks_cluster.cluster.certificate_authority.0.data
  sensitive = true
}
output "eks_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
###############################################################


###############################################################
# Key-pair
###############################################################
output "jumpbox_key_pair_fingerprint" {
  value = module.key_pair_jumpbox.this_key_pair_fingerprint
}
output "jumpbox_key_pair_private_pem" {
  value     = tls_private_key.jumpbox.private_key_pem
  sensitive = true
}
output "eks_key_pair_fingerprint" {
  value = module.key_pair_eks.this_key_pair_fingerprint
}
output "eks_key_pair_private_pem" {
  value     = tls_private_key.eks.private_key_pem
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

output "cluster_name" {
  value = var.cluster_name
}
