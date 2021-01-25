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
