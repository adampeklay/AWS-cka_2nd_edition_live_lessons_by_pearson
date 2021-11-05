# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cka-lab"
  cidr = "192.168.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["192.168.4.0/24"]
  public_subnets  = ["192.168.104.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "cka-dev-lab"
  }
}
