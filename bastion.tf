resource "aws_security_group" "bastion-sg" {
  name        = "bastion"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ter-vpc.id

  ingress {
    description      = "ssh port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.myip
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_key_pair" "keyfile" {
  key_name   = "terra-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgoxWGDX4hDaNDB2KcePUx9xfkugajgY7Rvv12yBQSCP46bICrB82EyW6N+BFQtnC3nT6aywdyudJsDMH5ZBbrsJaeKCRoUgXAcYjoeysFtapcV6zxXls+QFK70d8AM3sHpGZiWEnrizu6v5/rVoFc2wYyqVdvsKRYGz3Xd2QIO8S//yRyZCOYMguk9PPaCqhVMs1YfDi39nm4Oz91WkAowza4esRreOIl45F5/8FOd7ghJbURJJk6IlXdhEypJn26pLGMhzg3UU6abwy2X2mVEinxgMwRGL8sxdlZCwj3SYwAIGSTsiVBPB4AVupv/93TztOffZ73qBapAGre4s1WjxTl+pT93gkL0OHauXoaq7iquHgsHh7UF60sjCPh8d+Jzlii6Y3snCaanyzuCan9/l8GfJ0GqsnpFaXAtqFCF7331FROgcMvfeLrx4PtKpf9rnpYh0R9wyY6MGoB9ZVaQ5RAsaEPWp5cW3vDTM9nomlBK5vIB9LXezgjoHXKbBk= Budda Prasad@DESKTOP-74ENKBL"
}

resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.type
  subnet_id = aws_subnet.pubsubnet[0].id
  key_name = aws_key_pair.keyfile.id 
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
 
  tags = {
    Name = "ec2-bastion"
  }
}