#!/usr/bin/env bash
# Install Jenkins LTS from the official apt repo on Ubuntu/Debian (non-Docker setup).
# Jenkins is bound to 127.0.0.1 so only Nginx can reach it.
# If "apt update" reports a key error, get the current key URL from
# https://www.jenkins.io/doc/book/installing/linux/
set -euo pipefail

sudo apt update
sudo apt install -y fontconfig openjdk-21-jre wget

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins

# Listen on localhost only
sudo mkdir -p /etc/systemd/system/jenkins.service.d
printf '[Service]\nEnvironment="JENKINS_LISTEN_ADDRESS=127.0.0.1"\n' | \
  sudo tee /etc/systemd/system/jenkins.service.d/override.conf > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable --now jenkins
sudo systemctl restart jenkins

echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
