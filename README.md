### BestBuy Autocomplete

Dataset used: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)

#### Requirements
- Go 1.13
- Java 11
- Elasticsearch 7.10
- Node.js 14.14.0

#### Instructions (local)

1. `curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-linux-x86_64.tar.gz`
2. `tar -xvf elasticsearch-7.10.2-linux-x86_64.tar.gz`
3. `gunzip --keep data/products.json.gz > data/products.json`
4. `./elasticsearch-7.10.2/bin/elasticsearch -p /tmp/es-pid1 &`
5. `go run go/*.go`
6. `node web/app.js`
7. web server running on localhost, port 3000
