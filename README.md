### BestBuy Autocomplete

Dataset used: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)

#### Software used
- go1.15.6
- Node v14.14.0
- Docker version 20.10.2
- Helm v3.5.0
- Kind version 0.9.0
- Kubernetes v1.19.1
- Terraform v0.14.5

#### Instructions (v3 - Local Kubernetes)

- kind create cluster --config kind-configs/elastic-cluster.yaml --name bestbuy-elastic
- kind create cluster --config kind-configs/web-cluster.yaml --name bestbuy-web
- docker build -t bestbuy-web:1.0 -f ./web/Dockerfile ./web
- kind load docker-image bestbuy-web:1.0 --name bestbuy-web
- terraform init
- terraform apply
- go build
- ./es-indexer -addr="http://localhost:30080"
- go to [localhost:31080](localhost:31080)

#### Demo

![demo](images/local.gif)
