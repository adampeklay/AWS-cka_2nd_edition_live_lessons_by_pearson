# cka_2nd_edition_live_lessons_by_pearson
Packer and Terraform modules used to spin up a CKA cluster, spec'd out as required by the [CKA 2nd Edition Video course published by Pearson IT Certification](https://www.pearsonitcertification.com/store/certified-kubernetes-administrator-cka-complete-video-9780137438372).


## General information
Each AWS resource is a Terraform root module, which is created by calling modules from various [terraform-aws-modules](https://github.com/terraform-aws-modules) repositories.  

The `packer` directory has a brief README as well.  You can read this README top down to get this lab built fairly quickly.  

You will be instructed to start in the `packer` directory to get the AMI built, further below.  

## Local requirements
- Install Packer, I used version `1.7.8`
- Install AWS CLI, and you have your AWS access keys configured locally in `~/.aws`.  You may likely have this done already, for your AWS personal account.
- Install Terraform.  I used `0.14.0`.  Use [tfenv](https://github.com/tfutils/tfenv) to install `0.14.0` if you'd like.
- We'll need an ssh key-pair, please name it `cka_lab_rsa` as that is what this code references.  We'll need that key created and/or placed its usual spot, `~/.ssh`.

```
user ~ $ ssh-keygen
..
..

user ~ $ ll .ssh | grep cka
-rw-------   1 user  staff   2.5K Nov  8 15:48 cka_lab_rsa
-rw-r--r--   1 user  staff   578B Nov  8 15:48 cka_lab_rsa.pub
user ~ $
```

### INPUTS
Due to the nature of the lab, there won't be too many inputs for you to provide.  

I've included a `cka_lab.tfvars` file, which requires 3 variables to be declared (you can pick another region, or leave that as is):

```
region = "us-east-1a"

public_key = ""

my_current_ip = ""
```

All the other variables in `variables.tf` should remain the same, as they are spec'd per the lab instructor.. for lab parity.



### OUTPUTS
After terraform is ran, we'll get the public IP of the `kube_controller`, so we can ssh to the controller:
```
Outputs:

kube_controller_public_ip = "55.55.55.55"
```

## Building the Lab
1.  First head over to the `packer` directory.  You'll see another README that will show you how to get the AMI built, that is required for this lab.  It should only take you about 5 minutes to subscribe an a CentOS 7 AMI and run 1 packer command.  Once you're done with that, proceed to step 2 below.

2.  Now we can spin up the lab.  You'll get an IP address you can ssh to, using the private key from the keypair you created previously.  You don't have to include `--auto-approve` if you don't want to. 
- you must `cd ..` and go back into the root of the repo to run Terraform, as you were previously working in the the `packer` directory for step 1.
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
```
SSH to the controller using the `centos` user, and the ssh key we created earlier:
```
$ ssh -i ~/.ssh/cka_lab centos@55.55.55.55
```
SSH key based authentication is configured on all instances, `/etc/hosts` and `~/.ssh/config` will be all setup too.  That being said, you can ssh to any instance via the hostname, such as:
`ssh worker-1`, `ssh-worker-2`, `ssh-worker-3`, `ssh controller`

When you're done, destroy all the resources to keep your AWS bill nice and low.
```
terraform destroy --var-file=cka_lab.tfvars --auto-approve
```

## How long will it take to spin up the lab?
For Packer, roughly `7 minutes` to create the AMI:
```
Build 'cka lab ami.amazon-ebs.k8s-lab-ami' finished after 6 minutes 53 seconds.

==> Wait completed after 6 minutes 53 seconds
```
For Terraform, roughly `1.5 minutes`:
```
21:10 $ date
Wed Feb 16 21:10:20 CST 2022
✔ ~/github/cka_2nd_edition_live_lessons_by_pearson [main|✚ 3⚑ 4] 
21:10 $ terraform apply --var-file=cka_lab.tfvars --auto-approve
..
..
..
✔ ~/github/cka_2nd_edition_live_lessons_by_pearson [main|✚ 3⚑ 4] 
21:11 $ date
Wed Feb 16 21:11:57 CST 2022

```
Total time: `~8.5 minutes`

## When you're completely done with the lab and no longer need to use it anymore
- The only artifacts left that you'll want to delete should be the ami we created.
- You can unsubscribe from the CentOS 7 AMI when you're done with the lab as well, and remove that AMI from your account too.

That should be it, as everything managed by Terraform will be destroyed when you destroy it.
