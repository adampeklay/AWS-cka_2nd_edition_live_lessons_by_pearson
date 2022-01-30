data "aws_ami" "cka_lab_ami" {
  name_regex  = "^k8s-lab-ami"
  most_recent = true
  owners      = ["self"]
}
