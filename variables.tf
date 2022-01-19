// Any variable without a default is to be declared in cka_lab.tfvars
variable "key_name" {
  type        = string
  description = "The SSH keypair to use via ssh to the ec2 instances"
  default     = "cka_lab"
}

variable "controller_instance_type" {
  type        = string
  description = "the instance type for the kubernetes controller instance(s)"
  default     = "t3a.small"
}

variable "worker_instance_type" {
  type        = string
  description = "the instance type for the kubernetes worker instance(s)"
  default     = "t2.micro"
}

variable "my_current_ip" {
  type        = string
  description = "needed for ingress security group, set value in cka_lab.tfvars file"
}
