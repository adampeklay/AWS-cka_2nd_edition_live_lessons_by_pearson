# cka_2nd_edition_live_lessons_by_pearson
Packer AMI code and Terraform root modules used to spin up a CKA cluster, spec'd out as required by the [CKA 2nd Edition Video course published by Pearson IT Certification](https://www.pearsonitcertification.com/store/certified-kubernetes-administrator-cka-complete-video-9780137438372).


### General information
WIP 


Each AWS resource is a Terraform root module, which is created by calling modules from various [terraform-aws-modules](https://github.com/terraform-aws-modules) repositories.  

## Local requirements

### WIP turn this into a local bash setup script once all the manual steps are noted  

We'll need an ssh key-pair:  

```
user ~ $ ssh-keygen
..
..

user ~ $ ll .ssh|grep cka
-rw-------   1 user  staff   2.5K Nov  8 15:48 cka_lab_rsa
-rw-r--r--   1 user  staff   578B Nov  8 15:48 cka_lab_rsa.pub
user ~ $
```

We'll need to set the follow local environment variables in your terminal:

```
export TF_VAR_my_current_ip=$(curl -4 icanhazip.com)\/32
export TF_VAR_public_key="your public key you created in quotes"

```
TODO:  

- PACKER: var for packer owner / aws cli to script for centos AMI. Get the owner string for var definition, subscribe, etc
- extra steps in the lab, finish watching 3.1 and update packer script calls
- tags



### INPUTS

TODO:  
- tfvar inputs

### OUTPUTS
After terraform is ran, we'll get the public IP of the `kube_controller`, so we can ssh to the cluster:
```
Outputs:

kube_controller_public_ip = "55.55.55.55"
```

## Usage
TODO:  
- instructions for packer after thats all automated
- aws cli setup (optional)
- tfenv (optional)
- terraform validate, terraform fmt, terraform plan
- tweak the overall layout of the USAGE section for ease of use

Spin up the lab, you'll get an IP address you can ssh to using the private key from the keypair you created previously, using the ssh user `centos`:
```
terraform apply --var-file=cka_lab.tfvars --auto-approve
...
...
...
module.cka_lab_vpc.aws_route.private_nat_gateway[0]: Creating...
module.cka_lab_vpc.aws_route.private_nat_gateway[0]: Creation complete after 1s [id=r-rtb-05d3fe23d26942ba71080289494]

Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

kube_controller_public_ip = "55.55.55.55"
$ ssh -i ~/.ssh/cka_lab centos@55.55.55.55
```
When you're done, destroy all the resources to keep your AWS bill nice and low.
```
terraform destroy --var-file=cka_lab.tfvars --auto-approve
```
