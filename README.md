### BestBuy - autocomplete

#### Problem statement

Consider BestBuy wants some advice on how to implement an autocomplete feature that provides real-
time, low latency suggestions as a user types in a search phrase for their global user base. They currently
have a product catalogue of around 3 million objects and only want to autocomplete the product name.

Data Resources: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)

#### Terraform workspaces
- tfstates/provision_vpc_and_eks
- tfstates/deploy_elastic_cluster_resources
- tfstates/deploy_web_cluster_resources

#### Requirements
- the latest version of [Terraform](https://www.terraform.io/)
- [wget](https://www.gnu.org/software/wget/), to retrieve terraform modules
- an [AWS account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) with IAM permissions listed on the [EKS module documentation](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md)
- a configured [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/), to install kubernetes packages
- [Docker engine](https://docs.docker.com/get-docker/)

#### Option 1

![arch1](images/bestbuy-arch1.png)

#### Option 2

![arch2](images/bestbuy-arch2.png)

#### Demo

![demo](images/cloud.gif)
