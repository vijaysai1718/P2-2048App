#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
Normal="\e[0m"
user=$(id -u)

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
echo -e "Installation of $2 is $RED Failure $Normal"
exit
else
echo -e "Installation of $2 is $GREEN Success $Normal"
fi


# Install Terraform

wget -O - https://apt.releases.hashicorp.com/gpg |  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
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
 apt-get install unzip -y
unzip awscliv2.zip
 ./aws/install
validate $? "Aws CLI"

#Installing the Docker

 apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
 systemctl enable docker &&  systemctl start docker
 apt install docker-ce docker-ce-cli containerd.io -y
 usermod -aG docker ubuntu
 newgrp docker
 chmod 777 /var/run/docker.sock
 validate $? "Docker"
 



 #Installation of jenkins 
 apt update &&  apt upgrade -y
 apt install openjdk-17-jdk -y
 curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
 echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian binary/ |  tee /etc/apt/sources.list.d/jenkins.list > /dev/null
 apt update
 apt install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins

 #Installation of trivy 
 apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor |  tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" |  tee -a /etc/apt/sources.list.d/trivy.list
 apt-get update
 apt-get install trivy -y


# eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
eksctl version
VALIDATE $? "eksctl installation"

