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

echo "----- configuring Jenkins HTTPS -----"
KEYSTORE_DIR="/var/lib/jenkins/https"
KEYSTORE_PATH="${KEYSTORE_DIR}/jenkins.p12"
KEYSTORE_PASSWORD="$(openssl rand -hex 24)"
PUBLIC_IP="$(curl --fail --silent --max-time 3 -X PUT \
	-H 'X-aws-ec2-metadata-token-ttl-seconds: 60' \
	http://169.254.169.254/latest/api/token | xargs -r -I{} curl --fail --silent --max-time 3 \
	-H 'X-aws-ec2-metadata-token: {}' \
	http://169.254.169.254/latest/meta-data/public-ipv4 || true)"
HOST_FQDN="$(hostname -f 2>/dev/null || true)"
SAN="DNS:localhost,IP:127.0.0.1"
if [ -n "${PUBLIC_IP}" ]; then
	SAN="${SAN},IP:${PUBLIC_IP}"
fi
if [ -n "${HOST_FQDN}" ]; then
	SAN="${SAN},DNS:${HOST_FQDN}"
fi

sudo install -d -o jenkins -g jenkins -m 700 "${KEYSTORE_DIR}"
sudo -u jenkins keytool -genkeypair \
	-alias jenkins \
	-keyalg RSA \
	-keysize 2048 \
	-validity 3650 \
	-storetype PKCS12 \
	-keystore "${KEYSTORE_PATH}" \
	-storepass "${KEYSTORE_PASSWORD}" \
	-keypass "${KEYSTORE_PASSWORD}" \
	-dname "CN=${HOST_FQDN:-localhost}" \
	-ext "SAN=${SAN}"

sudo install -d -m 755 /etc/systemd/system/jenkins.service.d
sudo tee /etc/systemd/system/jenkins.service.d/https.conf >/dev/null <<EOF
[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
Environment="JENKINS_OPTS=--httpPort=-1 --httpsPort=443 --httpsKeyStore=${KEYSTORE_PATH} --httpsKeyStorePassword=${KEYSTORE_PASSWORD} --httpsKeyStoreType=PKCS12"
EOF
sudo chmod 600 /etc/systemd/system/jenkins.service.d/https.conf
sudo systemctl daemon-reload
sudo systemctl enable jenkins.service

sudo systemctl restart jenkins.service

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