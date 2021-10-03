resource "aws_elasticache_subnet_group" "cache" {
  name       = "tf-cache-subnet"
  subnet_ids = module.vpc.elasticache_subnets
}

resource "aws_elasticache_replication_group" "cache" {
  replication_group_id          = "tf-redis-cluster"
  replication_group_description = "caches elasticsearch queries"
  node_type                     = "cache.t2.micro"
  multi_az_enabled              = true
  automatic_failover_enabled    = true
  engine                        = "redis"
  engine_version                = "3.2.4"
  parameter_group_name          = "default.redis3.2.cluster.on"
  subnet_group_name             = aws_elasticache_subnet_group.cache.name
  security_group_ids            = [module.elasticache_sg.security_group_id]
  port                          = 6379

  cluster_mode {
    replicas_per_node_group = 2
    num_node_groups         = 1
  }
}
