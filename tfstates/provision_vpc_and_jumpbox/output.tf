output "aws_region" {
  value = var.region
}

output "aws_load_balancer_iam_policy" {
  value = aws_iam_policy.policy.arn
}

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

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "list of this vpc's private subnet ids"
  value       = module.vpc.private_subnets
}

output "vpc_private_subnet_cidrs" {
  value = var.vpc_private_subnets
}

output "vpc_public_subnets" {
  description = "list of this vpc's public subnet ids"
  value       = module.vpc.public_subnets
}

output "vpc_public_subnet_cidrs" {
  value = var.vpc_public_subnets
}

output "jumpbox_key_pair_fingerprint" {
  value = module.key_pair.this_key_pair_fingerprint
}

output "jumpbox_key_pair_private_pem" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "jumpbox_public_ip" {
  value = module.jumpbox.public_ip
}

output "jumpbox_sg_id" {
  value = module.jumpbox_sg.this_security_group_id
}
