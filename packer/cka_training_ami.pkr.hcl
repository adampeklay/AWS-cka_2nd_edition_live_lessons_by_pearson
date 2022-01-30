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

  ami_script = "bootstrap_ami.sh"

  ec2_script = "ec2.sh"

  aws_profile = "default"
}

source "amazon-ebs" "k8s-lab-ami" {
  region                = local.region
  profile               = local.aws_profile
  ami_name              = "k8s-lab-ami"
  instance_type         = local.instance_type
  force_deregister      = true
  force_delete_snapshot = true
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
}

build {
  name = "cka lab ami"
  sources = [
    "source.amazon-ebs.k8s-lab-ami"
  ]

  provisioner "file" {
    source      = "${local.script_dir}/${local.ec2_script}"
    destination = "$HOME/${local.ec2_script}"
  }

  provisioner "shell" {
    script = "${local.script_dir}/${local.ami_script}"
  }
}
