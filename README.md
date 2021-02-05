### BestBuy Autocomplete (v4 - AWS Cloud - standalone instances)

Dataset used: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)

#### Software used
- go1.15.6
- Node v14.14.0
- Docker version 20.10.2
- Kubernetes
- Terraform v0.14.5

#### Terraform workspaces (backend only)
- tfstates/provision_vpc_and_jumpbox
- tfstates/provision_elastic_cluster
- tfstates/deploy_elastic_cluster_resources

#### Demo

![demo](images/local.gif)
