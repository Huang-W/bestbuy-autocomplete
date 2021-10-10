resource "aws_elasticache_subnet_group" "cache" {
  name       = "elasticache-subnets"
  subnet_ids = data.terraform_remote_state.infrastructure.outputs.elasticache_subnet_ids
}

resource "aws_elasticache_replication_group" "cache" {
  replication_group_id          = "bestbuy-redis-cluster"
  replication_group_description = "caches elasticsearch queries"
  node_type                     = "cache.t3.micro"
  multi_az_enabled              = false
  engine                        = "redis"
  engine_version                = "6.x"
  subnet_group_name             = aws_elasticache_subnet_group.cache.name
  security_group_ids            = [data.terraform_remote_state.infrastructure.outputs.elasticache_security_group_id]
  port                          = 6379
}
