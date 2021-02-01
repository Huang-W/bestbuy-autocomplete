### BestBuy Autocomplete (v4 - AWS Cloud - standalone instances)

Dataset used: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)

#### Software used
- go1.15.6
- Node v14.14.0
- Docker version 20.10.2
- Terraform v0.14.5

#### Terraform Input

- `my_home_network: your public ipv4 address as cidr block`
- `my_aws_public_key: the public key associated with each ec2 instance`

#### Demo

![demo](images/local.gif)
