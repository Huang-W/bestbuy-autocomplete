# Key pair for access to bastion host
########################################################
resource "random_pet" "a" {
  length = 2
}
resource "tls_private_key" "a" {
  algorithm = "RSA"
}
module "key_pair_jumpbox" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.a.id
  public_key = tls_private_key.a.public_key_openssh
}
########################################################


# Key pair for access to elastic nodes
########################################################
resource "random_pet" "b" {
  length = 2
}
resource "tls_private_key" "b" {
  algorithm = "RSA"
}
module "key_pair_elastic" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.b.id
  public_key = tls_private_key.b.public_key_openssh
}
########################################################


# Key pair for access to web nodes
########################################################
resource "random_pet" "c" {
  length = 2
}
resource "tls_private_key" "c" {
  algorithm = "RSA"
}
module "key_pair_web" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = random_pet.c.id
  public_key = tls_private_key.c.public_key_openssh
}
########################################################
