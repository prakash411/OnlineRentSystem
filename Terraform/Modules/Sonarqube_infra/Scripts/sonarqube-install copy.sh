#!/bin/bash

sudo -i

# Update system
yum update -y

# Install Java 21
yum install -y java-21-amazon-corretto-devel

# Install PostgreSQL 15
yum install -y postgresql15 postgresql15-server

# Initialize PostgreSQL
postgresql-setup --initdb

# Enable and start PostgreSQL
systemctl enable postgresql
systemctl start postgresql

# --------------------------------------------------
# Configure PostgreSQL authentication
# --------------------------------------------------

# Allow password authentication for local TCP connections
sed -i \
  -e 's/^\(host[[:space:]]\+all[[:space:]]\+all[[:space:]]\+127\.0\.0\.1\/32[[:space:]]\+\).*/\1scram-sha-256/' \
  -e 's/^\(host[[:space:]]\+all[[:space:]]\+all[[:space:]]\+::1\/128[[:space:]]\+\).*/\1scram-sha-256/' \
  /var/lib/pgsql/data/pg_hba.conf

# Reload PostgreSQL configuration
systemctl reload postgresql

# --------------------------------------------------
# Create SonarQube database and user
# --------------------------------------------------

sudo -u postgres psql <<EOF
CREATE USER sonar WITH ENCRYPTED PASSWORD 'StrongPassword123';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

# --------------------------------------------------
# Install SonarQube
# --------------------------------------------------

cd /opt

wget -O sonarqube.zip \
  "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.8.0.126808.zip"

unzip sonarqube.zip

mv sonarqube-26.8.0.126808 sonarqube

# Create SonarQube system user
useradd --system --no-create-home --shell /bin/bash sonarqube

# Set ownership
chown -R sonarqube:sonarqube /opt/sonarqube

# --------------------------------------------------
# Configure SonarQube database
# --------------------------------------------------

sed -i \
  -e 's|^#sonar.jdbc.username=.*|sonar.jdbc.username=sonar|' \
  -e 's|^#sonar.jdbc.password=.*|sonar.jdbc.password=StrongPassword123|' \
  -e 's|^#sonar.jdbc.url=.*|sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube|' \
  /opt/sonarqube/conf/sonar.properties

# --------------------------------------------------
# Configure kernel parameters for SonarQube
# --------------------------------------------------

sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

cat > /etc/sysctl.d/99-sonarqube.conf <<EOF
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system

# --------------------------------------------------
# Configure SonarQube limits
# --------------------------------------------------

cat > /etc/security/limits.d/99-sonarqube.conf <<EOF
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192
EOF

# --------------------------------------------------
# Test PostgreSQL connection
# --------------------------------------------------

PGPASSWORD='StrongPassword123' \
psql -h 127.0.0.1 -U sonar -d sonarqube -c "SELECT 1;"

if [ $? -ne 0 ]; then
    echo "ERROR: SonarQube PostgreSQL connection failed."
    exit 1
fi

echo "PostgreSQL connection successful."

# --------------------------------------------------
# Create SonarQube systemd service
# --------------------------------------------------

cat > /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube service
After=network.target postgresql.service
Requires=postgresql.service

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

# --------------------------------------------------
# Start SonarQube
# --------------------------------------------------

systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube


# Check SonarQube API

echo
echo "Checking SonarQube..."

curl -s http://localhost:9000/api/system/status

echo
echo "SonarQube installation completed."
