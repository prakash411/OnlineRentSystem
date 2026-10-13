#!/bin/bash
echo "===== SonarQube installation script started ====="
set -e
echo "----- update packages -----"
sudo yum update -y

echo "----- installing java -----"
sudo yum install -y java-21-amazon-corretto-devel

echo "----- downloading SonarQube -----"
cd /opt
sudo wget "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.8.0.126808.zip"
sudo unzip sonarqube-26.8.0.126808
sudo mv sonarqube-26.8.0.126808 sonarqube

echo "----- creating sonarqube user -----"
sudo useradd --system --no-create-home --shell /bin/bash sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube


echo "----- Create SonarQube systemd service -----"
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=network.target 

[Service]
Type=forking
User=sonarqube
Group=sonarqube

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=on-failure
RestartSec=10

LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

echo "----- enabling SonarQube service -----"
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

echo "----- Check SonarQube service -----"
sudo systemctl status sonarqube --no-pager

echo "===== SonarQube installation script completed ====="
