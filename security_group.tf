resource "aws_security_group" "cka_lab" {
  name        = "cka lab"
  description = "allows instances to communicate with eachother, ssh from home"
  vpc_id      = module.cka_lab_vpc.vpc_id

  ingress = [
    {
      description = "instance to instance"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks      = []
      self             = true
      ipv6_cidr_blocks = [] #
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "ssh from home"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.home_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "cka lab"
  }
}