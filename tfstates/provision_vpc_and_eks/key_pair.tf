# Key pair for access to bastion host
########################################################
resource "random_pet" "jumpbox" {
  length = 2
}
resource "tls_private_key" "jumpbox" {
  algorithm = "RSA"
}
module "key_pair_jumpbox" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.jumpbox.id
  public_key = tls_private_key.jumpbox.public_key_openssh
}
########################################################


# Key pair for access to eks worker nodes
########################################################
resource "random_pet" "eks" {
  length = 2
}
resource "tls_private_key" "eks" {
  algorithm = "RSA"
}
module "key_pair_eks" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.eks.id
  public_key = tls_private_key.eks.public_key_openssh
}
########################################################
