
#Getting the ubuntu Image 
 data "aws_ami" "ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"] # Change for different versions
  }
}

data "aws_vpc" "vpc-id" {
    default = true
}


data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc-id.id]
  }

#provide your availability-zone here
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

