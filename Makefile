format-tf:
	terraform fmt -recursive .

format-go:
	gofmt -w -s .

format-web:
	npm --prefix ./web run format

pre-commit:
	pre-commit run --all-files

ssh-ec2:
	ssh -i $(pem) ec2-user@$(addr)

scp-ec2:
	scp -i $(pem) $(f) ec2-user@$(addr):/home/ec2-user

get-all:
	kubectl get all --all-namespaces

get-pods:
	kubectl get pods

pod-dnsutils:
	kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml

gitlab-apply:
	kubectl apply -f gitlab-admin-service-account.yaml

gitlab-token:
	kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab | awk '{print $1}')
