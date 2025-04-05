#!/bin/bash
RED="\e[30m"
GREEN="\e[31m"
Normal= "\e[32m"
user=$ ( id -u )

if [ $user -ne 0 ] 
then 
echo "please run  script with the super user"
exit 1
else
echo "you are the super user installation will be inprogress"
fi

validate()
if [ $1 -ne 0 ]
then 
echo -e "Installation of $2 is $RED Failure"
exit
else
echo -e "Installation of $2 is $GREEN Success"
fi


# Install Terraform

wget -O - https://apt.releases.hashicorp.com/gpg |  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update &&  apt install terraform
validate $? "Terraform"


# Install kubectl
apt update
apt install curl -y
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
validate $? "Kubectl"


# Install AWS CLI 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip -y
unzip awscliv2.zip
sudo ./aws/install
validate $? "Aws CLI"

#Installing the Docker

 apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
 systemctl enable docker &&  systemctl start docker
 apt install docker-ce docker-ce-cli containerd.io -y
 usermod -aG docker ubuntu
 newgrp docker