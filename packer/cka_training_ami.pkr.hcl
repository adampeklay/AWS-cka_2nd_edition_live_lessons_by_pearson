packer {
  required_plugins {
    amazon = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  instance_type = "t2.micro"

  region = "us-east-1"

  source_ami_filter_name = "CentOS-7-20200923-2003.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42-ami-0c5a39cd417835870.4"

  owners = ["679593333241"]

  ssh_username = "centos"

  script_dir = "./scripts"

  script = "bootstrap_ami.sh"

  controller = "kube controller"

  worker = "kube worker"

  aws_profile = "packer"
}

source "amazon-ebs" "centos-kube-controller" {
  region        = local.region
  profile       = local.aws_profile
  ami_name      = "${local.controller}-{{timestamp}}"
  instance_type = local.instance_type
  source_ami_filter {
    filters = {
      name                = local.source_ami_filter_name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = "false"
    owners      = local.owners
  }
  ssh_username = local.ssh_username
  tags = {
    Name = local.controller
  }
}

source "amazon-ebs" "centos-kube-worker" {
  ami_name      = "${local.worker}-{{timestamp}}"
  instance_type = local.instance_type
  region        = local.region
  profile       = local.aws_profile
  source_ami_filter {
    filters = {
      name                = local.source_ami_filter_name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = "false"
    owners      = local.owners
  }
  ssh_username = local.ssh_username
  tags = {
    Name = local.worker
  }
}

build {
  name = "cka lab"
  sources = [
    "source.amazon-ebs.centos-kube-controller",
    "source.amazon-ebs.centos-kube-worker"
  ]

  provisioner "shell" {
    script = "${local.script_dir}/${local.script}"
  }
}