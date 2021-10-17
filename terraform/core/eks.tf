resource "aws_eks_cluster" "eks01" {
  name     = "eks01"
  role_arn = aws_iam_role.eks01.arn
  version  = "1.21"

  vpc_config {
    subnet_ids          = data.terraform_remote_state.infrastructure.outputs.pv1_subnet_ids
    public_access_cidrs = toset(["0.0.0.0/0"])
  }

  kubernetes_network_config {
    service_ipv4_cidr = data.terraform_remote_state.infrastructure.outputs.eks01_service_ipv4_cidr
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

data "aws_security_group" "eks01_cluster_sg" {
  tags = {
    "aws:eks:cluster-name"                                = aws_eks_cluster.eks01.name
    "kubernetes.io/cluster/${aws_eks_cluster.eks01.name}" = "owned"
  }
}

output "eks01_cluster_sg_name" {
  value = data.aws_security_group.eks01_cluster_sg.name
}

output "endpoint" {
  value = aws_eks_cluster.eks01.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks01.certificate_authority[0].data
}

resource "aws_iam_role" "eks01" {
  name = "eks01-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Full policy can be found below
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks01.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks01.name
}
