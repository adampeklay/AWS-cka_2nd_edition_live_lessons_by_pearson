// These IPs are hardcoded for the lab per the lab setup requirements
module "cka_lab_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.11"

  name = "cka-lab"
  cidr = var.cidr

  azs             = [var.region]
  private_subnets = [var.private_subnets]
  public_subnets  = [var.public_subnets]

  enable_nat_gateway     = true
  single_nat_gateway     = true

  tags = {
    Terraform   = "true"
    Environment = "cka-dev-lab"
  }
}
