output "node_key_pair_fingerprint" {
  value = module.key_pair.this_key_pair_fingerprint
}

output "node_key_pair_private_pem" {
  value = tls_private_key.this.private_key_pem
  sensitive = true
}

output "aws_region" {
    value = data.terraform_remote_state.vpc.outputs.aws_region
}

output "cluster_id" {
    value = module.eks_elastic.cluster_id
}

output "eks_cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_ca_cert" {
  value = data.aws_eks_cluster.cluster.certificate_authority.0.data
  sensitive = true
}

output "eks_cluster_oidc_issuer_url" {
  value = module.eks_elastic.cluster_oidc_issuer_url
}

output "aws_load_balancer_iam_policy" {
  value = data.terraform_remote_state.vpc.outputs.aws_load_balancer_iam_policy
}
