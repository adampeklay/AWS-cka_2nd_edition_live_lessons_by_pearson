// These IPs are hardcoded for the lab per the lab setup requirements
module "cka_lab_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.11"

  name = "cka-lab"
  cidr = "192.168.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["192.168.4.0/24"]
  public_subnets  = ["192.168.104.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true

  tags = {
    Terraform   = "true"
    Environment = "cka-dev-lab"
  }
}
