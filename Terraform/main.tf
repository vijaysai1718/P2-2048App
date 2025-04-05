resource "aws_instance" "workstation" {

instance_type = "t3.medium"
ami = data.aws_ami.ami.id
tags = {
    Name = "WorkStation"
}
key_name = aws_key_pair.secretkey.key_name
user_data = file("Installation.sh")
vpc_security_group_ids = [aws_security_group.sg_id.id]

root_block_device {
    volume_size = 30        # 30 GB EBS
    volume_type = "gp2"     # General Purpose SSD (can be gp3 too)
  }

}

#creating the key pair 
resource "aws_key_pair" "secretkey" {
    key_name   = "secret"
   public_key = file("E:/DevopsAws/secret_key.pub")
}

# creating the security group and allowing required traffic
resource "aws_security_group" "sg_id" {

 name = "allow_ssh_http"
 description = "allow ssh and http traffic"
 dynamic ingress {
    for_each = var.securitygroupids
    content {
       from_port = ingress.value["from_port"]
    to_port = ingress.value["to_port"]
    protocol =ingress.value["protocol"]
    cidr_blocks =ingress.value["cidr_blocks"]
 }
    }
   

 egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}