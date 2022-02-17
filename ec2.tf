// public subnet
module "kube_controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.2"

  name = var.controller_name

  ami                         = data.aws_ami.cka_lab_ami.id
  instance_type               = var.controller_instance_type
  key_name                    = var.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.cka_lab.id]
  subnet_id                   = module.cka_lab_vpc.public_subnets[0]
  private_ip                  = var.controller_private_ip
  associate_public_ip_address = true
}

// private subnet
module "kube_worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.2"

  count = length(var.worker_private_ip)
  name  = "${var.worker_name}-${(count.index)}"

  ami                    = data.aws_ami.cka_lab_ami.id
  instance_type          = var.worker_instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cka_lab.id]
  subnet_id              = module.cka_lab_vpc.private_subnets[0]
  private_ip             = var.worker_private_ip[count.index]
}

// ec2 instance key pair
resource "aws_key_pair" "cka_lab" {
  key_name   = var.key_name
  public_key = var.public_key
}
