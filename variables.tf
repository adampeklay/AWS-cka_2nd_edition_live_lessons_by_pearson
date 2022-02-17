variable "key_name" {
  type        = string
  description = "The SSH keypair to use via ssh to the ec2 instances"
  default     = "cka_lab"
}

variable "lab_name" {
  type        = string
  description = "generic Name value for resources"
  default     = "cka lab"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy the cluster in.  Set in cka_lab.tfvars."
}

variable "public_key" {
  type        = string
  description = "used for ssh key based auth to the k8s controller node.  Set in cka_lab.tfvars."
}

variable "my_current_ip" {
  type        = string
  description = "Your IP address that's needed for the ingress security group.  Set in cka_lab.tfvars."
}

variable "controller_name" {
  type        = string
  description = "The kubernetes controller name"
  default     = "kube-controller"
}

variable "worker_name" {
  type        = string
  description = "The kubernetes worker names"
  default     = "kube-worker"
}

variable "controller_instance_type" {
  type        = string
  description = "The instance type for the kubernetes controller instance(s)"
  default     = "t3a.small"
}

variable "worker_instance_type" {
  type        = string
  description = "The instance type for the kubernetes worker instance(s)"
  default     = "t2.micro"
}

variable "cidr" {
  type        = string
  description = "the CIDR block for the lab"
  default     = "192.168.0.0/16"
}

variable "private_subnet" {
  type        = list(string)
  description = "The private subnet the lab will use"
  default     = ["192.168.4.0/24"]
}

variable "public_subnet" {
  type        = list(string)
  description = "The public subnet the lab will use"
  default     = ["192.168.104.0/24"]
}

variable "controller_private_ip" {
  type        = string
  description = "private controller ip required by the lab"
  default     = "192.168.104.110"
}

variable "worker_private_ip" {
  type        = list(string)
  description = "private work ips required by the lab"
  default     = ["192.168.4.111", "192.168.4.112", "192.168.4.113"]
}

variable "lab_tags" {
  type        = map(string)
  description = "basic tag for lab resources"
  default = {
    Name    = "cka lab",
    Created = "terraform"
  }
}
