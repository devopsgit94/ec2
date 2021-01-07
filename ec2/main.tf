provider "aws"{
    region = "us-west-2"
    access_key = "AKIAIYQTAYTLS5SMRQ7Q"
    secret_key = "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"
}


data "aws_availability_zones" "available" {}


data "template_file" "init" {
  template = file("${path.module}/userdata.tpl")
  #path.module is nothing but current working directory
}

#resource "aws_key_pair" "mytest-key" {
  #key_name   = "my-test-terraform-key-new1"
  #public_key = file(var.my_public_key)
#}

resource "aws_instance" "my-test-instance" {
  count                  = 2
  ami                    = "ami-0a36eb8fadc976275"
  instance_type          = var.instance_type
  key_name               = "main-key"
  vpc_security_group_ids = [var.security_group]
  subnet_id              = element(var.subnets, count.index )
  #element is a function here
  user_data              = data.template_file.init.rendered

  tags = {
    Name = "my-instance-${count.index + 1}"
  }
}