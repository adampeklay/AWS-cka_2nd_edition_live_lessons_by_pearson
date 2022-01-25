module "cka_lab_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.11"

  name = "cka-lab"
  cidr = var.cidr

  azs             = [var.region]
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet

  enable_nat_gateway = true
  single_nat_gateway = true
//add tags
}
