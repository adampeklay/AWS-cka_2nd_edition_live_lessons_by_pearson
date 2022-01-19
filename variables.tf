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
  description = "Needed for ingress security group, set value in cka_lab.tfvars file"
}

variable "cidr" {
  type = string
  description = "the CIDR block for the lab"
  default = "192.168.0.0/16"
}


variable "private_subnets" {
  type = list
  description = "The private subnet the lab will use"
  default = ["192.168.4.0/24"]
}

variable "public_subnets" {
  type = list
  description = "The public subnet the lab will use"
  default = ["192.168.104.0/24"]
}

variable "region" {
  type = string
  description = "The AWS region to deploy the cluster in"
}

// variablize tags too