#!/bin/bash
echo "===== Jenkins installation script started ====="
set -e
echo "----- update packages -----"
sudo yum update -y

echo "----- installing java -----"
sudo yum install java-21-amazon-corretto-devel -y

echo "----- installing jenkins -----"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service

echo "----- installing git -----"
sudo yum install git -y

echo "----- installing dotnet -----"
sudo yum install dotnet -y

echo "----- setting up dotnet tools -----"
sudo mkdir -p /var/lib/jenkins/.dotnet-tools
sudo chown -R jenkins:jenkins /var/lib/jenkins/.dotnet-tools
cd /var/lib/jenkins
sudo -u jenkins -H dotnet tool install --tool-path /var/lib/jenkins/.dotnet-tools dotnet-sonarscanner

echo "===== Jenkins installation script completed ====="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "===== Initial Admin Password ====="