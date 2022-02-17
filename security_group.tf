resource "aws_security_group" "cka_lab" {
  name        = var.lab_name
  description = "allows instances to communicate with eachother, ssh from home, outbound internet"
  vpc_id      = module.cka_lab_vpc.vpc_id

  ingress = [
    {
      description      = "instance to instance"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = []
      self             = true
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "ssh from home"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.my_current_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.lab_tags
}
