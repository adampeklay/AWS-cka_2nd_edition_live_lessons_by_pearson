// Any variable without a default is to be declared in cka_lab.tfvars
variable "key_name" {
  type        = string
  description = "The SSH keypair to use via ssh to the ec2 instances"
  default     = "cka_lab"
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

variable "my_current_ip" {
  type        = string
  description = "LOCAL ENV VAR: Needed for ingress security group"
  //export TF_VAR_my_current_ip=$(curl -4 icanhazip.com)/\32

}

variable "cidr" {
  type        = string
  description = "the CIDR block for the lab"
  default     = "192.168.0.0/16"
}


variable "private_subnet" {
  type        = list(any)
  description = "The private subnet the lab will use"
  default     = ["192.168.4.0/24"]
}

variable "public_subnet" {
  type        = list(any)
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

variable "region" {
  type        = string
  description = "The AWS region to deploy the cluster in"
}

variable "public_key" {
  type        = string
  description = "LOCAL ENV VAR: used for ssh key based auth to the k8s controller node"
  //export TF_var_public_key="your public key in quotes"
}

// variablize tags too
