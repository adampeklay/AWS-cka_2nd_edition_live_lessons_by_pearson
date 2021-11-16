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
}

// ec2 instance key pair - refrerence any local keypair you wish to use
resource "aws_key_pair" "cka_lab" {
  key_name   = "cka_lab"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKqRlh/p8tRQioJLxk8W/+dfc0ynQDQMrGLaGmMb4qfHj+OSPiovoI2A1pQiXB1CUKNgCnp+9nsnCj0Dl/P+JUdtzcD07jT2B6fMRyXb19hexpBXxjWPvV/NpCAV94rszafXxTktQ4+1ar0HN+AZQgwBel34RTA2EUJvtHu2nmWQIUcLQeoBSFfCKo8k1hgaOZudHII1Z9DKQUweioBIvBPDPN3u8q3konApRXGB6rn/lHrBwn+J4rAw6EvSFqlKUFvJk7LJXS2j2In9EQWnbVG2XdzYEv7HBsZEAx5bxxOMxb1r3P1XYufbR9YwAYQKTRzckjwaF8upamZdO6N23OLMscfXFJcCoLs+6MR/kaIe2HZzI6WFuBnNIq/QMsjHZjNQpHujEG62l/b0PGfZ/iVq+969Ztk+eJ5NDZhYIIPE8tQZgZcCjPfvw7/tbLgTzLc/xS/tallAZOTOGI5cUVJ+e8515Hq+0fbw/+V1D5/7eItpIZChUE3KQcU1qEMl8="
}