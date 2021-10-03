region                    = "us-west-2"
vpc_name                  = "bestbuy-devnet"
vpc_cidr                  = "10.1.0.0/16"
private_subnets           = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
public_subnets            = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
elasticache_subnets       = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
subnet_availability_zones = ["usw2-az1", "usw2-az2", "usw2-az3"]

cluster_name = "bestbuy-autocomplete"