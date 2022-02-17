# Packer AMI for CKA lab
## Background
I took advantage of some pandemic downtime and got everything we need to have for the lab, baked into an AMI.  

Using linux `at` jobs, we can programmatically finish boostrapping the ec2 instances after they're created fromt the AMI.  

```
==> cka lab ami.amazon-ebs.k8s-lab-ami: + logger 'at job scheduled successfully, hostnames will be set upon ec2 creation'
==> cka lab ami.amazon-ebs.k8s-lab-ami: + sudo at now +2 minute -f /home/centos/ec2.sh
==> cka lab ami.amazon-ebs.k8s-lab-ami: job 1 at Thu Feb 17 01:11:00 2022
==> cka lab ami.amazon-ebs.k8s-lab-ami: + '[' 0 -eq 0 ']'
==> cka lab ami.amazon-ebs.k8s-lab-ami: + logger 'at job scheduled successfully, hostnames will be set upon ec2 creation'
```

Combined with Terraform, we can spin up and spin down our labs at our leisure.  This will help us keep our AWS costs down on our personal AWS accounts.  

### Steps required for making the AMI:
- subscribe to the AMI specified below
- run `packer build .` in the `packer` directory

---
## Subscribe to a specific CentOS 7 AMI
In the AWS Console or using the CLI, you'll want to subscribe to this specific Centos7 AMI.  Log into the AWS Console and click on the URL below:
- [CentOS 7 (x86_64) - with Updates HVM](https://console.aws.amazon.com/marketplace/home?region=us-east-1#/subscriptions/d9a3032a-921c-4c6d-b150-bde168105e42)

If you use another Centos7 AMI, you'll need to update the following default values, in the `cka_training_ami.pkr.hcl` file:
- `source_ami_filter_name = "CentOS-7-20200923-2003.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42-ami-0c5a39cd417835870.4"`
- `owners = ["679593333241"]`
---
## Build the AMI
Once you've completed the step above, execute the following command in the `packer` directory:

`packer build .`  

The AMI will be build in maybe ~10 minutes.  

---

Let's go back to the main README in this repo, and start step `2` of "Building the Lab".
