### BestBuy Autocomplete (v4 - AWS Cloud - standalone instances)

Dataset used: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)

#### Terraform workspaces
- tfstates/provision_vpc_and_jumpbox
- tfstates/provision_elastic_cluster
- tfstates/provision_web_cluster
- tfstates/deploy_elastic_cluster_resources
- tfstates/deploy_web_cluster_resources

#### Requirements
- the latest version of [Terraform](https://www.terraform.io/)
- [wget](https://www.gnu.org/software/wget/), to retrieve terraform modules
- an [AWS account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) with IAM permissions listed on the [EKS module documentation](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md)
- a configured [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- a [Go install](https://golang.org/doc/install) with module support
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/), to install kubernetes packages
- [Docker engine](https://docs.docker.com/get-docker/)

#### Demo

![demo](images/local.gif)
