format-tf:
	terraform fmt -recursive .

format-go:
	gofmt -w -s .

format-web:
	npm --prefix ./web run format

ssh-ec2:
	ssh -i $(pem) ec2-user@$(addr)

scp-ec2:
	scp -i $(pem) $(f) ec2-user@$(addr):/home/ec2-user

web-context:
	kubectl config use-context bestbuy-web

elastic-context:
	kubectl config use-context bestbuy-elastic

get-all:
	kubectl get all --all-namespaces

get-pods:
	kubectl get pods

pod-dnsutils:
	kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
