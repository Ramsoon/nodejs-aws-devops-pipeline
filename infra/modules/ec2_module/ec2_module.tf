

//ec2 instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
module "shared_vars" {
  source = "../shared_variables"
}
variable "keyn" {type = string}
variable "sg_id" {type = string}
variable "varsub" {type = string}
# variable "tagname" {
#   type = string
#   default = "EC2_Name_Instance_${module.shared_vars.env_suffix}"
# }


resource "aws_instance" "myec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg_id]
  subnet_id = "${var.varsub}"
  key_name = "${var.keyn}"

  # ensure the instance gets a public IP in a non-default subnet
  associate_public_ip_address = true

  tags = {
    Name = "EC2_Name_Instance_${module.shared_vars.env_suffix}"
  }
}

output "instance_id" {
  value = aws_instance.myec2.id
}

output "ec2_public_ip" {
  value = aws_instance.myec2.public_ip
}