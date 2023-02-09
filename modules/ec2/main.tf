resource "aws_key_pair" "ec2_key" {
  key_name   = "my-ec2"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "ec2" {
  count                       = 2
  ami                         = var.image_id
  key_name                    = aws_key_pair.ec2_key.key_name
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_id, count.index + 1)
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  user_data                   = <<-EOF
          #!/bin/bash
          echo "Hello, World" > index.html
          nohup busybox httpd -f -p ${var.server_port} &
          EOF


  tags = {
    Name = "ec2-${count.index + 1}"
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "port 22"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "port 8080"
      from_port        = 8080
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 8080
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "port 80"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
  }]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
