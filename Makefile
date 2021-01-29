format-tf:
	terraform fmt -recursive .

format-go:
	gofmt -w -s .

format-web:
	npm --prefix ./web run format

# v1 - Local
#
#
local-start:
	./elasticsearch-7.10.2/bin/elasticsearch -p /tmp/es-pid1 &
	./elasticsearch-7.10.2/bin/elasticsearch -Epath.data=data2 -Epath.logs=log2 -p /tmp/es-pid2 &
	./elasticsearch-7.10.2/bin/elasticsearch -Epath.data=data3 -Epath.logs=log3 -p /tmp/es-pid3 &

local-stop:
	[ -f /tmp/es-pid1 ] && kill $$(cat /tmp/es-pid1) && rm /tmp/es-pid1
	[ -f /tmp/es-pid2 ] && kill $$(cat /tmp/es-pid2) && rm /tmp/es-pid2
	[ -f /tmp/es-pid3 ] && kill $$(cat /tmp/es-pid3) && rm /tmp/es-pid3

local-insert:
	go run go/*.go

local-search:
	curl -X GET localhost:9200/products/_search?pretty -H 'Content-Type: application/json' -d @$(f)

# v2 - Docker
#
#
docker-build:
	docker build -t bestbuy-web:1.0 -f ./web/Dockerfile ./web

docker-run:
	docker run --name bestbuy-web -td -p 3000:3000 \
		-e DEPLOYMENT_TYPE=ENV \
		-e ES_ADDRESS=$(addr) \
		-e ES_PORT=$(port) \
		bestbuy-web

es-shell:
	docker exec -it es-node1 bash

web-shell:
	docker exec -it bestbuy-web bash

# v3 - Kubernetes (local)
#
#
web-context:
	kubectl config use-context kind-bestbuy-web

elastic-context:
	kubectl config use-context kind-bestbuy-elastic

get-all:
	kubectl get all --all-namespaces

get-pods:
	kubectl get pods

pod-dsnutils:
	kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
