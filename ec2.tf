// public subnet
module "kube-controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.2"

  name  = "kube-controller"

  ami                         = data.aws_ami.cka_lab_ami.id
  instance_type               = var.controller_instance_type
  key_name                    = var.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.cka_lab.id]
  subnet_id                   = module.cka_lab_vpc.public_subnets[0]
  associate_public_ip_address = true
// add tags
}

// private subnet
module "kube-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.2"

  count = 3
  name  = "kube-worker-${count.index}"

  ami                         = data.aws_ami.cka_lab_ami.id
  instance_type               = var.worker_instance_type
  key_name                    = var.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.cka_lab.id]
  subnet_id                   = module.cka_lab_vpc.private_subnets[0]
// add tags
}

// ec2 instance key pair - refrerence any local keypair's public key you wish to use
resource "aws_key_pair" "cka_lab" {
  key_name   = "cka_lab"
  public_key = var.public_key
}
