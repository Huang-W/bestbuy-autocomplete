### BestBuy - autocomplete

#### Scenario

Consider BestBuy wants some advice on how to implement an autocomplete feature that provides real-
time, low latency suggestions as a user types in a search phrase for their global user base. They currently
have a product catalogue of around 3 million objects and only want to autocomplete the product name.

#### Minimum requirement

- One recommended architecture and prototype running on public cloud (GCP/AWS) with details on how data flows through the system and descriptions of each component
- with one alternative architecture with pros/cons
- Estimated cloud calculation pricing for each architecture (GCP and AWS)

#### Considerations

- Using open-source tools/technology is preferred
- Serving a global user base with low latency
- What are some ways they could generate the autocomplete data?
- What types of systems could be used to store and serve the autocomplete data?

#### Data Resources:

- Sample dataset: [https://github.com/BestBuyAPIs/open-data-set](https://github.com/BestBuyAPIs/open-data-set)
- Try out [BestBuy's search engine](https://www.bestbuy.com/) for better understanding.

#### CI/CD Flow:

- Use Terraform to build basic infrastructure on public cloud (VPC, Subnet, security group, VMs, k8s, etc)
- Use public gitlab/github to store your code.
- Pack your autocomplete frontend app code in a docker container and deploy it in Kubernetes cluster.
- You can use gitlab-runner or Jenkins as your CICD tools to automate the flow from git => build => deploy in kubernetes cluster.

#### Option 1

![arch1](images/bestbuy-arch1.png)

#### Demo

![demo](images/cloud.gif)

#### Terraform workspaces

- tfstates/provision_vpc_and_eks
- tfstates/deploy_kubernetes_resources

#### Software used

- [Terraform](https://www.terraform.io/) v1.0.8
- [wget](https://www.gnu.org/software/wget/), required for aws eks module
- an [AWS account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) with IAM permissions listed on the [EKS module documentation](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md)
- a configured [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) client
- [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- [helm](https://helm.sh/), to install kubernetes packages
- [Docker engine](https://docs.docker.com/get-docker/)
- a [GitLab](https://about.gitlab.com/) repository for CI/CD
- Git [pre-commits](https://pre-commit.com/) (optional)
